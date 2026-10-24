import 'package:flutter/material.dart';

class BankCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final bool isDarkMode;

  const BankCardWidget({super.key, required this.cardNumber, required this.cardHolder, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final cardBgColor = isDarkMode ? const Color(0xFF161B22) : Colors.white;
    final mainTextColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey : const Color(0xFF6E7681);

    return SizedBox(
      width: double.infinity,
      height: 190,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.4 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PayBank',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 16),
                ),
                Icon(Icons.contactless, color: mainTextColor),
              ],
            ),
            Container(
              width: 42,
              height: 28,
              decoration: BoxDecoration(color: const Color(0xFFE2B714), borderRadius: BorderRadius.circular(6)),
            ),
            Text(
              cardNumber,
              style: TextStyle(color: mainTextColor, letterSpacing: 2, fontWeight: FontWeight.w600, fontSize: 18),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(cardHolder.toUpperCase(), style: TextStyle(color: subTextColor, fontSize: 12, letterSpacing: 1)),
                Text(
                  'VISA',
                  style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold, fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
