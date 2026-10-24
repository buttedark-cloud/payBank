import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class CurrencyRatesCard extends StatefulWidget {
  const CurrencyRatesCard({super.key});

  @override
  State<CurrencyRatesCard> createState() => _CurrencyRatesCardState();
}

class _CurrencyRatesCardState extends State<CurrencyRatesCard> {
  Map<String, dynamic>? _rates;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchRates();
  }

  Future<void> _fetchRates() async {
    try {
      // Запрос к публичному API Центробанка РФ (реальные актуальные курсы)
      final response = await Dio().get('https://www.cbr-xml-daily.cz/daily_json.js');
      if (mounted) {
        setState(() {
          _rates = response.data['Valute'];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Не удалось загрузить курсы';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        height: 90,
        alignment: Alignment.center,
        child: const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    if (_error != null || _rates == null) {
      return const SizedBox.shrink();
    }

    // Вытаскиваем нужные валюты: USD, EUR, CNY
    final usd = _rates!['USD']?['Value'] ?? 0.0;
    final eur = _rates!['EUR']?['Value'] ?? 0.0;
    final cny = _rates!['CNY']?['Value'] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Курсы валют ЦБ РФ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildCurrencyItem('USD', '$usd ₽'), _buildCurrencyItem('EUR', '$eur ₽'), _buildCurrencyItem('CNY', '$cny ₽')],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyItem(String symbol, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          symbol,
          style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
