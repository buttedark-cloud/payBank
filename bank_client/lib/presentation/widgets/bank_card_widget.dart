import 'package:flutter/material.dart';

class BankCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final bool isDarkMode;

  const BankCardWidget({super.key, required this.cardNumber, required this.cardHolder, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    final mainTextColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey : const Color.fromARGB(255, 33, 37, 43);

    return SizedBox(
      width: double.infinity,
      height: 220,

      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.0, -0.7),
            radius: 1.0,
            colors: isDarkMode
                ? [
                    const Color.fromARGB(255, 11, 84, 185), // Тёмный графит для тёмной темы
                    const Color(0xFF111827),
                  ]
                : [
                    const Color.fromARGB(255, 146, 185, 221), // Чистый белый для светлой темы (чтобы сразу было видно)
                    const Color.fromARGB(255, 58, 103, 185),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDarkMode ? Colors.amber.withValues(alpha: 0.4) : Colors.black12, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDarkMode ? 0.5 : 0.1),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Верхняя строка: Логотип банка и иконка NFC из интернета
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'PayBank',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 16),
                ),
                // Иконка бесконтактной оплаты (NFC) из сети
                Image.asset(
                  'assets/images/contactless.png',
                  width: 25,
                  height: 25,
                  color: mainTextColor,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.contactless, color: mainTextColor, size: 22),
                ),
              ],
            ),

            // Красивый золотой чип из интернета (вместо плоского квадрата)
            Image.network(
              'https://cdn-icons-png.flaticon.com/512/6404/6404078.png',
              width: 38,
              height: 28,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 38,
                height: 28,
                decoration: BoxDecoration(color: const Color(0xFFE2B714), borderRadius: BorderRadius.circular(6)),
              ),
            ),

            // Номер карты
            Text(
              cardNumber,
              style: TextStyle(color: mainTextColor, letterSpacing: 2, fontWeight: FontWeight.w600, fontSize: 18),
            ),

            // Нижняя строка: Имя владельца и VISA
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    cardHolder.toUpperCase(),
                    style: TextStyle(color: subTextColor, fontSize: 12, letterSpacing: 1, height: 1.2),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'VISA',
                  style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
