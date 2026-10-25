import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Логотип и название «PayBank» на экране регистрации
class RegisterLogo extends StatelessWidget {
  const RegisterLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final logoTextColor = isDarkMode ? Colors.white : const Color(0xFF1A2B42);

    return Row(
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
          style: GoogleFonts.playfairDisplay(fontSize: 40, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic, color: logoTextColor),
        ),
      ],
    );
  }
}
