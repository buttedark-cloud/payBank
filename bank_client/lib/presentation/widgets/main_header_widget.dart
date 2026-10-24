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
        // Левая часть (логотип + название) — оборачиваем в Expanded, чтобы она сжималась при нехватке места
        Expanded(
          child: Row(
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
              // Ограничиваем название, чтобы длинные строки не ломали верстку
              Flexible(
                child: Text(
                  'PayBank',
                  style: TextStyle(color: mainTextColor, fontSize: 20, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        // Правая часть с иконками (фиксированная, не давит на левую часть)
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode, color: mainTextColor),
              onPressed: () {
                themeNotifier.value = isDarkMode ? ThemeMode.light : ThemeMode.dark;
              },
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
            const SizedBox(width: 2),
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Профиль: $userName')));
              },
              borderRadius: BorderRadius.circular(18),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.blueAccent.withValues(alpha: 0.2),
                child: Text(
                  userName.isNotEmpty ? userName.substring(0, userName.length >= 2 ? 2 : userName.length).toUpperCase() : 'СП',
                  style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 11),
                ),
              ),
            ),
            const SizedBox(width: 2),
            IconButton(
              icon: Icon(Icons.notifications_none, color: mainTextColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Уведомлений нет')));
              },
              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ],
    );
  }
}
