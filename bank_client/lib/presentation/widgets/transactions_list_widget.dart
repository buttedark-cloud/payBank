import 'package:flutter/material.dart';

import 'transaction_item_widget.dart';

/// Заголовок «Последние операции» и сам список
class TransactionsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Color cardBgColor;
  final Color mainTextColor;
  final Color subTextColor;

  const TransactionsListWidget({
    super.key,
    required this.transactions,
    required this.cardBgColor,
    required this.mainTextColor,
    required this.subTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Последние операции',
          style: TextStyle(color: mainTextColor, fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...transactions.map(
          (tx) => TransactionItemWidget(
            cardBgColor: cardBgColor,
            mainTextColor: mainTextColor,
            subTextColor: subTextColor,
            icon: tx['icon'],
            iconColor: tx['color'],
            title: tx['title'],
            date: tx['date'],
            amount: tx['amount'],
            isNegative: tx['isNegative'],
          ),
        ),
      ],
    );
  }
}
