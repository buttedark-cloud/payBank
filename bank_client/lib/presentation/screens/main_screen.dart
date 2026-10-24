import 'package:flutter/material.dart';
import 'package:bank_client/presentation/widgets/widgets.dart';

class MainScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  final Map<String, dynamic> account;

  const MainScreen({
    super.key,
    this.user = const {'name': 'Сергей Панин'},
    this.account = const {'cardNumber': '4400-3201-7165-4352', 'balance': 5000.0},
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late double currentBalance;
  int _currentIndex = 0;

  final List<Map<String, dynamic>> transactions = [
    {
      'icon': Icons.account_balance,
      'color': Colors.greenAccent,
      'title': "Приветственный бонус",
      'date': "При регистрации",
      'amount': "+5,000.00 ₽",
      'isNegative': false,
    },
    {
      'icon': Icons.shopping_bag,
      'color': Colors.redAccent,
      'title': "Супермаркет 'Спар'",
      'date': "23 мая",
      'amount': "-3,450.00 ₽",
      'isNegative': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    currentBalance = double.tryParse(widget.account['balance'].toString()) ?? 5000.0;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final userName = widget.user['name'] ?? 'Сергей Панин';
    final cardNumber = widget.account['cardNumber'] ?? '4400-3201-7165-4352';

    final cardBgColor = isDarkMode ? const Color(0xFF161B22) : Colors.white;
    final mainTextColor = isDarkMode ? Colors.white : Colors.black87;
    final subTextColor = isDarkMode ? Colors.grey : const Color(0xFF6E7681);

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Шапка (Логотип, тема, профиль, уведомления)
              MainHeaderWidget(isDarkMode: isDarkMode, userName: userName),
              const SizedBox(height: 20),

              // Баланс
              BalanceWidget(balance: currentBalance, isDarkMode: isDarkMode),
              const SizedBox(height: 20),

              // Банковская карта
              BankCardWidget(cardNumber: cardNumber, cardHolder: userName, isDarkMode: isDarkMode),
              const SizedBox(height: 16),

              // Кнопки быстрых действий (Платежи, Пополнение)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.payment, size: 18),
                      label: const Text('Платежи'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_circle_outline, size: 18),
                      label: const Text('Пополнение'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Кнопка Перевода с идеальными пропорциями и иконками
              SizedBox(
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
                      onTap: () => showTransferModal(
                        context: context,
                        senderCard: cardNumber,
                        currentBalance: currentBalance,
                        isDarkMode: isDarkMode,
                        onTransferSuccess: (amount, recipient) {
                          setState(() {
                            currentBalance -= amount;
                            transactions.insert(0, {
                              'icon': Icons.arrow_outward,
                              'color': Colors.blueAccent,
                              'title': 'Перевод на карту $recipient',
                              'date': 'Только что',
                              'amount': '-${amount.toStringAsFixed(2)} ₽',
                              'isNegative': true,
                            });
                          });
                        },
                      ),
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
              ),
              const SizedBox(height: 24),

              // Список последних операций
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
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDarkMode ? const Color(0xFF090D16) : Colors.white,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: subTextColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: 'Платежи'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Счета'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
