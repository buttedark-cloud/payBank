import 'package:flutter/material.dart';

import '../../main.dart';

class MainHeaderWidget extends StatelessWidget {
  final bool isDarkMode;
  final String userName;

  const MainHeaderWidget({super.key, required this.isDarkMode, required this.userName});

  @override
  Widget build(BuildContext context) {
    final mainTextColor = isDarkMode ? Colors.white : Colors.black87;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/app_logo.png',
              width: 38,
              height: 38,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'PayBank',
              style: TextStyle(color: mainTextColor, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: mainTextColor),
              onPressed: () {
                themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              },
            ),
            const SizedBox(width: 4),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Профиль: $userName')));
              },
              borderRadius: BorderRadius.circular(18),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                child: Text(
                  userName.isNotEmpty ? userName.substring(0, 2).toUpperCase() : 'СП',
                  style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.notifications_none, color: mainTextColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Уведомлений нет')));
              },
            ),
          ],
        ),
      ],
    );
  }
}
