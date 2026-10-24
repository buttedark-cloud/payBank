import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; // Нужен для kIsWeb

import 'dart:developer' as developer;

class BankApiService {
  late final Dio _dio;

  BankApiService() {
    // Определяем правильный URL в зависимости от того, где запущено приложение:
    String baseUrl;

    if (kIsWeb) {
      // Если запущено в Chrome (веб)
      baseUrl = 'http://localhost:3000';
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      // Если это Android-эмулятор (он не видит localhost напрямую)
      baseUrl = 'http://10.0.2.2:3000';
    } else {
      // Для iOS-симулятора или реального десктопа/айфона по кабелю (впиши IP своего ПК, если на реальном телефоне)
      baseUrl = 'http://localhost:3000';
    }

    _dio = Dio(BaseOptions(baseUrl: baseUrl, connectTimeout: const Duration(seconds: 5), receiveTimeout: const Duration(seconds: 5)));
  }

  // 1. Метод регистрации пользователя
  Future<Map<String, dynamic>> registerUser(String name, String passportNumber) async {
    try {
      final response = await _dio.post(
        '/api/register', // <-- Добавили /api вот сюда!
        data: {'name': name, 'passportNumber': passportNumber},
      );
      return response.data;
    } catch (e) {
      throw Exception('Ошибка регистрации: $e');
    }
  }

  // 2. Метод получения данных карты/аккаунта
  Future<Map<String, dynamic>> getAccount(String cardNumber) async {
    try {
      final response = await _dio.get('/api/account/$cardNumber');
      return response.data;
    } catch (e) {
      throw Exception('Ошибка получения аккаунта: $e');
    }
  }

  // 3. Метод перевода денег
  Future<Map<String, dynamic>> transferMoney({
    required String senderCardNumber,
    required String recipientCardNumber,
    required double amount,
  }) async {
    try {
      // Вместо print используем developer.log
      developer.log('🚀 ОТПРАВЛЯЕМ ЗАПРОС НА: ${_dio.options.baseUrl}/api/transfer', name: 'BankApi');

      final response = await _dio.post(
        '/api/transfer',
        data: {'senderCardNumber': senderCardNumber, 'recipientCardNumber': recipientCardNumber, 'amount': amount},
      );
      return response.data;
    } catch (e) {
      developer.log('❌ ОШИБКА ДИО: $e', name: 'BankApi', error: e);
      throw Exception('Ошибка перевода: $e');
    }
  }
}
