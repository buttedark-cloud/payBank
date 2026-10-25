import 'package:bank_client/utils/money.dart';
import 'package:flutter/material.dart';

import 'package:bank_client/data/models/transaction_item.dart';

import 'transaction_item_widget.dart';

/// Заголовок «Последние операции» и сам список
class TransactionsListWidget extends StatelessWidget {
  final List<TransactionItem> transactions;
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
            icon: tx.isNegative ? Icons.arrow_outward : Icons.account_balance,
            iconColor: tx.isNegative ? Colors.blueAccent : Colors.greenAccent,
            title: tx.title,
            date: tx.date,
            amount: '${tx.isNegative ? '-' : '+'}${formatKopecks(tx.amount)} ₽',
            isNegative: tx.isNegative,
          ),
        ),
      ],
    );
  }
}
