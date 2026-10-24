part of 'bank_bloc.dart';

abstract class BankState extends Equatable {
  const BankState();

  @override
  List<Object?> get props => [];
}

// 1. Начальное состояние (приложение только открылось)
class BankInitial extends BankState {}

// 2. Состояние загрузки (крутится лоадер, ждем ответа от бэка)
class BankLoading extends BankState {}

// 3. Состояние успешной регистрации или получения счета
class BankAccountSuccess extends BankState {
  final Map<String, dynamic> accountData;

  const BankAccountSuccess(this.accountData);

  @override
  List<Object?> get props => [accountData];
}

// 4. Состояние успешного перевода денег
class BankTransferSuccess extends BankState {
  final Map<String, dynamic> transferData;

  const BankTransferSuccess(this.transferData);

  @override
  List<Object?> get props => [transferData];
}

// 5. Состояние ошибки (если сервер упал или ввели неверные данные)
class BankError extends BankState {
  final String message;

  const BankError(this.message);

  @override
  List<Object?> get props => [message];
}
