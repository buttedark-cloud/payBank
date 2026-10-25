import 'package:bank_client/presentation/modal/transfer_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bank_client/blocs/bank/bank_bloc.dart';
import 'package:bank_client/presentation/widgets/widgets.dart'; // Убедись, что путь к виджету курсов правильный

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

  // Данные последнего отправленного перевода (баланс обновим после ответа сервера)
  double? _pendingAmount;
  String? _pendingRecipient;

  // Ключ для принудительного обновления курсов валют извне
  final GlobalKey<CurrencyRatesCardState> _ratesKey = GlobalKey();

  final List<Map<String, dynamic>> transactions = [
    {
      'icon': Icons.account_balance,
      'color': Colors.greenAccent,
      'title': "Приветственный бонус",
      'date': "При регистрации",
      'amount': "+5,000.00 ₽",
      'isNegative': false,
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

    return BlocListener<BankBloc, BankState>(
      listener: (context, state) {
        if (state is BankTransferSuccess) {
          final amount = _pendingAmount ?? 0;
          final newBalance = (state.transferData['senderNewBalance'] as num?)?.toDouble() ?? (currentBalance - amount);
          setState(() {
            currentBalance = newBalance;
            transactions.insert(0, {
              'icon': Icons.arrow_outward,
              'color': Colors.blueAccent,
              'title': 'Перевод на карту ${_pendingRecipient ?? ''}',
              'date': 'Только что',
              'amount': '-${amount.toStringAsFixed(2)} ₽',
              'isNegative': true,
            });
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Перевод выполнен'), backgroundColor: Colors.green));
        } else if (state is BankError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.redAccent));
        }
      },
      child: Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF0D1117) : const Color(0xFFF6F8FA),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await _ratesKey.currentState?.refreshRates();
            },
            child: SingleChildScrollView(
              // Обязательно для свайпа, даже если контент не заполняет весь экран по высоте
              physics: const AlwaysScrollableScrollPhysics(),
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

                  // Карусель банковских карт
                  CardCarouselWidget(cardNumber: cardNumber, cardHolder: userName, isDarkMode: isDarkMode),
                  const SizedBox(height: 16),

                  // Курсы валют с ключом для обновления
                  CurrencyRatesCard(key: _ratesKey),
                  const SizedBox(height: 16),

                  // Кнопки быстрых действий
                  const QuickActionsWidget(),
                  const SizedBox(height: 12),

                  // Кнопка перевода
                  TransferButtonWidget(
                    cardBgColor: cardBgColor,
                    mainTextColor: mainTextColor,
                    subTextColor: subTextColor,
                    isDarkMode: isDarkMode,
                    onTap: () => showTransferModal(
                      context: context,
                      senderCard: cardNumber,
                      currentBalance: currentBalance,
                      isDarkMode: isDarkMode,
                      onTransferSuccess: (amount, recipient) {
                        _pendingAmount = amount;
                        _pendingRecipient = recipient;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Список последних операций
                  TransactionsListWidget(
                    transactions: transactions,
                    cardBgColor: cardBgColor,
                    mainTextColor: mainTextColor,
                    subTextColor: subTextColor,
                  ),
                ],
              ),
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
      ),
    );
  }
}
