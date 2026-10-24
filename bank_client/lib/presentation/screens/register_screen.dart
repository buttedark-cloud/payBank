import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../blocs/bank/bank_bloc.dart';
import 'main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _cardController = TextEditingController();

  final _cardMask = MaskTextInputFormatter(mask: '####-####-####-####', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final logoTextColor = isDarkMode ? Colors.white : const Color(0xFF1A2B42);

    // Бледный цвет только для плейсхолдеров (подсказок)
    final subtleHintColor = theme.colorScheme.onSurfaceVariant.withOpacity(0.4);

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

                    // Логотип из ассетов
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
                      decoration: InputDecoration(
                        labelText: 'ФИО', // Заголовок остался на месте
                        hintText: 'Александр Иванов',
                        hintStyle: TextStyle(color: subtleHintColor, fontSize: 14), // Бледный и мелкий ТОЛЬКО текст-пример
                      ),
                    ),
                    const SizedBox(height: 20),

                    // --- ПОЛЕ НОМЕРА КАРТЫ ---
                    TextField(
                      controller: _cardController,
                      inputFormatters: [_cardMask],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Номер карты', // Заголовок на месте
                        hintText: '4514-1234-5678-1234',
                        hintStyle: TextStyle(color: subtleHintColor, fontSize: 14), // Бледный и мелкий ТОЛЬКО текст-пример
                      ),
                    ),
                    const SizedBox(height: 40),

                    SizedBox(
                      height: 55,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = _nameController.text.trim();

                          final cardNumber = _cardController.text.replaceAll('-', '').trim();

                          if (name.isNotEmpty && cardNumber.length == 16) {
                            context.read<BankBloc>().add(
                              RegisterUserEvent(name: name, passportNumber: '1234567890', cardNumber: cardNumber),
                            );
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(content: Text('Введите ФИО и корректный номер карты (16 цифр)')));
                          }
                        },
                        child: const Text('Создать аккаунт'),
                      ),
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

                    BlocListener<BankBloc, BankState>(
                      listener: (context, state) {
                        if (state is BankAccountSuccess) {
                          final userData = state.accountData['user'] ?? {'name': _nameController.text};
                          final accountData = state.accountData['account'] ?? state.accountData;

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MainScreen(user: userData, account: accountData),
                            ),
                          );
                        } else if (state is BankError) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red));
                        }
                      },
                      child: const SizedBox.shrink(),
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
