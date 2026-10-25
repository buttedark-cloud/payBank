import 'package:flutter/material.dart';

/// Большая кнопка «Перевести» на главном экране
class TransferButtonWidget extends StatelessWidget {
  final Color cardBgColor;
  final Color mainTextColor;
  final Color subTextColor;
  final bool isDarkMode;
  final VoidCallback onTap;

  const TransferButtonWidget({
    super.key,
    required this.cardBgColor,
    required this.mainTextColor,
    required this.subTextColor,
    required this.isDarkMode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: Container(
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDarkMode ? Colors.transparent : Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.arrow_outward, color: Colors.blueAccent, size: 22),
                      const SizedBox(width: 16),
                      Text(
                        'Перевести',
                        style: TextStyle(color: mainTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  Icon(Icons.chevron_right, color: subTextColor, size: 22),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
