import 'package:equatable/equatable.dart';

/// Счёт пользователя, который приходит с сервера
class Account extends Equatable {
  final String name;
  final String phone;
  final String cardNumber;
  final int balance; // в копейках

  const Account({required this.name, required this.phone, required this.cardNumber, required this.balance});

  /// Превращает JSON от сервера в объект
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      name: json['name']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      cardNumber: json['cardNumber'] as String,
      balance: (json['balance'] as num).toInt(),
    );
  }

  @override
  List<Object?> get props => [name, phone, cardNumber, balance];
}
