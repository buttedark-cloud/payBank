import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:bank_client/data/services/api_constants.dart';

class CurrencyRatesCard extends StatefulWidget {
  const CurrencyRatesCard({super.key});

  @override
  State<CurrencyRatesCard> createState() => CurrencyRatesCardState();
}

class CurrencyRatesCardState extends State<CurrencyRatesCard> {
  Map<String, dynamic>? _rates;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    refreshRates();
  }

  Future<void> refreshRates() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
    });

    try {
      // Добавляем timestamp (?t=...) и заголовки, чтобы полностью исключить кэширование
      final response = await Dio().get(
        '${ApiConstants.baseUrl}/rates',
        queryParameters: {'_t': DateTime.now().millisecondsSinceEpoch},
        options: Options(headers: {'Cache-Control': 'no-cache, no-store, must-revalidate', 'Pragma': 'no-cache', 'Expires': '0'}),
      );

      if (mounted) {
        setState(() {
          final data = response.data;
          if (data is Map && data['rates'] != null) {
            _rates = Map<String, dynamic>.from(data['rates']);
          } else if (data is Map) {
            _rates = Map<String, dynamic>.from(data);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white70 : Colors.black54;

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );
    }

    final rub = (_rates?['RUB'] as num?)?.toDouble() ?? 92.5;
    final eur = (_rates?['EUR'] as num?)?.toDouble() ?? 0.92;
    final cny = (_rates?['CNY'] as num?)?.toDouble() ?? 7.2;

    final usdStr = rub.toStringAsFixed(2);
    final eurStr = (rub / (eur > 0 ? eur : 0.92)).toStringAsFixed(2);
    final cnyStr = (rub / (cny > 0 ? cny : 7.2)).toStringAsFixed(2);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Используем Flexible, чтобы на ультра-узких экранах тексты сжимались, но не ломали верстку
          Flexible(child: _buildCurrencyItem('USD', '$usdStr ₽', textColor)),
          const SizedBox(width: 4),
          Flexible(child: _buildCurrencyItem('EUR', '$eurStr ₽', textColor)),
          const SizedBox(width: 4),
          Flexible(child: _buildCurrencyItem('CNY', '$cnyStr ₽', textColor)),
        ],
      ),
    );
  }

  Widget _buildCurrencyItem(String symbol, String value, Color textColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$symbol: ',
          style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.w600),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
