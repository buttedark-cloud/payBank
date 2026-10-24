import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dart:async'; // Нужно для таймера плашки

import '../../blocs/bank/bank_bloc.dart';
import 'main_screen.dart';

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
    final isDarkMode = theme.brightness == Brightness.dark;

    final logoTextColor = isDarkMode ? Colors.white : const Color(0xFF1A2B42);
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

                    // Логотип
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.translate(
                          offset: const Offset(2, 0),
                          child: Image.asset(
                            'assets/images/app_logo.png',
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(color: theme.primaryColor, borderRadius: BorderRadius.circular(12)),
                              child: const Icon(Icons.account_balance_wallet, color: Colors.white),
                            ),
                          ),
                        ),
                        Text(
                          'PayBank',
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 40,
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.italic,
                            color: logoTextColor,
                          ),
                        ),
                      ],
                    ),
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

                    // --- КРАСНАЯ ПЛАШКА «СЕРВЕР ПРОСЫПАЕТСЯ» ---
                    if (_isServerWakingUp)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              child: Text(
                                'Идет подготовка данных, загрузка может занять до 30 секунд, пожалуйста, подождите...',
                                style: TextStyle(color: Colors.redAccent, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),

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
                              builder: (context) => MainScreen(
                                user: {'name': _nameController.text.trim()},
                                account: state.accountData['account'] ?? {'phone': _phoneMask.getUnmaskedText(), 'balance': 5000.0},
                              ),
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
                                        RegisterUserEvent(name: name, passportNumber: '1234567890', cardNumber: phoneForApi),
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
