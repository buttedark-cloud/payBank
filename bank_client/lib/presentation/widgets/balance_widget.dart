import 'package:flutter/material.dart';

class BalanceWidget extends StatelessWidget {
  final double balance;
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
          '${balance.toStringAsFixed(2)} ₽',
          style: TextStyle(color: mainTextColor, fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
