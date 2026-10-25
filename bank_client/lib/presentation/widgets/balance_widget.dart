import 'package:flutter/material.dart';
import 'package:bank_client/utils/money.dart';

class BalanceWidget extends StatelessWidget {
  final int balance;
  final bool isDarkMode;

  const BalanceWidget({super.key, required this.balance, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final mainTextColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey : const Color(0xFF6E7681);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Баланс', style: TextStyle(color: subTextColor, fontSize: 14)),
        const SizedBox(height: 4),
        Text(
          '${formatKopecks(balance)} ₽',
          style: TextStyle(color: mainTextColor, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
