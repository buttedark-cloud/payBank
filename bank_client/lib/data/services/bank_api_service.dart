import 'package:dio/dio.dart';

import 'dart:async';
import 'dart:developer' as developer;

import 'package:bank_client/data/services/api_constants.dart';

class BankApiService {
  late final Dio _dio;

  BankApiService() {
    _dio = Dio(
      BaseOptions(baseUrl: ApiConstants.baseUrl, connectTimeout: const Duration(seconds: 60), receiveTimeout: const Duration(seconds: 60)),
    );
  }

  // Достаёт понятное сообщение: ответ сервера или текст про связь
  String _errorMessage(Object e, String fallback) {
    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map && data['message'] != null) {
        return data['message'].toString();
      }
      return 'Нет связи с сервером. Попробуйте ещё раз';
    }
    return fallback;
  }

  // 1. Метод регистрации пользователя
  Future<Map<String, dynamic>> registerUser(String name, String passportNumber) async {
    try {
      final response = await _dio.post('/api/register', data: {'name': name, 'passportNumber': passportNumber});
      return response.data;
    } catch (e) {
      throw Exception(_errorMessage(e, 'Ошибка регистрации'));
    }
  }

  // 2. Метод получения данных карты/аккаунта
  Future<Map<String, dynamic>> getAccount(String cardNumber) async {
    try {
      final response = await _dio.get('/api/account/$cardNumber');
      return response.data;
    } catch (e) {
      throw Exception(_errorMessage(e, 'Ошибка получения аккаунта'));
    }
  }

  // 3. Метод перевода денег
  Future<Map<String, dynamic>> transferMoney({
    required String senderCardNumber,
    required String recipientCardNumber,
    required double amount,
  }) async {
    try {
      developer.log('🚀 ОТПРАВЛЯЕМ ЗАПРОС НА: ${_dio.options.baseUrl}/api/transfer', name: 'BankApi');

      final response = await _dio.post(
        '/api/transfer',
        data: {'senderCardNumber': senderCardNumber, 'recipientCardNumber': recipientCardNumber, 'amount': amount},
      );
      return response.data;
    } catch (e) {
      developer.log('❌ ОШИБКА ДИО: $e', name: 'BankApi', error: e);
      throw Exception(_errorMessage(e, 'Ошибка перевода'));
    }
  }
}
