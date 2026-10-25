import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'dart:async'; // Нужно для таймера плашки

import '../../blocs/bank/bank_bloc.dart';
import 'main_screen.dart';
import 'package:bank_client/presentation/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Контроллеры полей ввода
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;

  // Состояние для плашки «сервер просыпается»
  bool _isServerWakingUp = false;
  Timer? _wakeUpTimer;

  // Маска для телефона: +7 (999) 123-45-67
  final _phoneMask = MaskTextInputFormatter(mask: '+7 (###) ###-##-##', filter: {"#": RegExp(r'[0-9]')}, type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();

    // Безопасная инициализация контроллера телефона с готовой маской
    final initialText = _phoneMask.formatEditUpdate(TextEditingValue.empty, const TextEditingValue(text: '')).text;

    _phoneController = TextEditingController(text: initialText);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _wakeUpTimer?.cancel();
    super.dispose();
  }

  // Функция запуска таймера ожидания
  void _startServerWakeUpTimer() {
    setState(() {
      _isServerWakingUp = false;
    });

    // Если через 5 секунд запрос всё еще идет — показываем красную плашку
    _wakeUpTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _isServerWakingUp = true;
        });
      }
    });
  }

  // Отмена таймера, когда ответ пришел
  void _cancelServerWakeUpTimer() {
    _wakeUpTimer?.cancel();
    if (mounted && _isServerWakingUp) {
      setState(() {
        _isServerWakingUp = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final subtleHintColor = theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.4);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24.0),
              sliver: SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    const RegisterLogo(),
                    const SizedBox(height: 40),

                    Text('Регистрация', style: theme.textTheme.displayLarge),
                    const SizedBox(height: 8),
                    Text('Создайте ваш аккаунт в PayBank!', style: theme.textTheme.bodyLarge),
                    const SizedBox(height: 32),

                    // --- ПОЛЕ ФИО ---
                    TextField(
                      controller: _nameController,
                      maxLength: 100,
                      decoration: InputDecoration(
                        labelText: 'ФИО',
                        hintText: 'Александр Иванов',
                        hintStyle: TextStyle(color: subtleHintColor, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- ПОЛЕ НОМЕРА ТЕЛЕФОНА ---
                    TextField(
                      controller: _phoneController,
                      inputFormatters: [_phoneMask],
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Номер телефона',
                        hintText: '+7 (999) 123-45-67',
                        hintStyle: TextStyle(color: subtleHintColor, fontSize: 14),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Плашка «сервер просыпается»
                    if (_isServerWakingUp) const ServerWakeUpBanner(),

                    BlocConsumer<BankBloc, BankState>(
                      listener: (context, state) {
                        if (state is! BankLoading) {
                          // Если загрузка закончилась (успех или ошибка) — гасим таймер и плашку
                          _cancelServerWakeUpTimer();
                        }

                        if (state is BankAccountSuccess) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainScreen(account: state.account),
                            ),
                          );
                        } else if (state is BankError) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent));
                        }
                      },
                      builder: (context, state) {
                        final isLoading = state is BankLoading;

                        return SizedBox(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                                    final name = _nameController.text.trim();
                                    final unmaskedPhone = _phoneMask.getUnmaskedText();
                                    final phoneForApi = '+7$unmaskedPhone';

                                    if (name.isNotEmpty && unmaskedPhone.length == 10) {
                                      // Запускаем таймер пятисекундного ожидания сервера
                                      _startServerWakeUpTimer();

                                      context.read<BankBloc>().add(
                                        RegisterUserEvent(
                                          name: name,
                                          passportNumber: phoneForApi, // Используем телефон как паспорт/уникальный ID
                                          cardNumber: phoneForApi, // Передаем его же, чтобы компилятор не ругался на отсутствие параметра
                                        ),
                                      );
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(content: Text('Введите ФИО и корректный номер телефона (+7...)')));
                                    }
                                  },
                            child: isLoading
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                                  )
                                : const Text('Создать аккаунт', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Уже есть аккаунт?', style: TextStyle(fontSize: 16)),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text('Войти', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
