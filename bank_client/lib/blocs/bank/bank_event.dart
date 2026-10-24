part of 'bank_bloc.dart';

abstract class BankEvent extends Equatable {
  const BankEvent();

  @override
  List<Object?> get props => [];
}

// Событие регистрации пользователя
class RegisterUserEvent extends BankEvent {
  final String name;
  final String passportNumber;
  final String cardNumber; // <--- Добавляем поле для карты

  const RegisterUserEvent({
    required this.name,
    required this.passportNumber,
    required this.cardNumber, // <--- Добавляем в конструктор
  });

  @override
  List<Object?> get props => [name, passportNumber, cardNumber]; // <--- Не забываем добавить в props для Equatable
}

// Событие получения информации о счете
class GetAccountEvent extends BankEvent {
  final String cardNumber;

  const GetAccountEvent({required this.cardNumber});

  @override
  List<Object?> get props => [cardNumber];
}

// Событие перевода средств
class TransferMoneyEvent extends BankEvent {
  final String senderCardNumber;
  final String recipientCardNumber;
  final double amount;

  const TransferMoneyEvent({required this.senderCardNumber, required this.recipientCardNumber, required this.amount});

  @override
  List<Object?> get props => [senderCardNumber, recipientCardNumber, amount];
}
