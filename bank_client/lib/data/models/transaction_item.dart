/// Одна операция в списке «Последние операции»
class TransactionItem {
  final String title;
  final String date;
  final int amount;
  final bool isNegative;

  const TransactionItem({required this.title, required this.date, required this.amount, required this.isNegative});
}
