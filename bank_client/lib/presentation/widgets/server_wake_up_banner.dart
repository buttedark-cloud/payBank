import 'package:flutter/material.dart';

/// Красная плашка «сервер просыпается» на экране регистрации
class ServerWakeUpBanner extends StatelessWidget {
  const ServerWakeUpBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withValues(alpha: 0.4)),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Text(
              'Идет подготовка данных, загрузка может занять до 30 секунд, пожалуйста, подождите...',
              style: TextStyle(color: Colors.redAccent, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
