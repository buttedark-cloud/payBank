import 'package:flutter/material.dart';

class TransactionItemWidget extends StatelessWidget {
  final Color cardBgColor;
  final Color mainTextColor;
  final Color subTextColor;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String date;
  final String amount;
  final bool isNegative;

  const TransactionItemWidget({
    super.key,
    required this.cardBgColor,
    required this.mainTextColor,
    required this.subTextColor,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.date,
    required this.amount,
    required this.isNegative,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: cardBgColor, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Левая часть с иконкой и текстом
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.15), shape: BoxShape.circle),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 12),
                // Оборачиваем колонку текста в Expanded, чтобы длинные названия не ломали верстку
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold, fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        date,
                        style: TextStyle(color: subTextColor, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Правая часть с суммой (фиксированная, не сжимается)
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: isNegative ? Colors.redAccent : Colors.greenAccent),
          ),
        ],
      ),
    );
  }
}
