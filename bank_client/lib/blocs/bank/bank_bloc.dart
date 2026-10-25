import 'package:bank_client/data/services/bank_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Подключаем наши дочерние файлы событий и состояний
part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankApiService _apiService;

  // Обязательный конструктор, который мы случайно затерли!
  BankBloc(this._apiService) : super(BankInitial()) {
    // 1. Обработка события регистрации
    on<RegisterUserEvent>((event, emit) async {
      emit(BankLoading()); // Показываем лоадер
      try {
        final result = await _apiService.registerUser(event.name, event.passportNumber);
        emit(BankAccountSuccess(result)); // Успех! Передаем данные
      } catch (e) {
        emit(const BankError('Ошибка регистрации. Возможно, этот номер уже зарегистрирован.'));
      }
    });

    // 2. Обработка события получения счета/карты
    on<GetAccountEvent>((event, emit) async {
      emit(BankLoading());
      try {
        final result = await _apiService.getAccount(event.cardNumber);
        emit(BankAccountSuccess(result));
      } catch (e) {
        emit(BankError(e.toString()));
      }
    });

    // 3. Обработка события перевода денег
    on<TransferMoneyEvent>((event, emit) async {
      emit(BankLoading());
      try {
        final result = await _apiService.transferMoney(
          senderCardNumber: event.senderCardNumber,
          recipientCardNumber: event.recipientCardNumber,
          amount: event.amount,
        );
        emit(BankTransferSuccess(result)); // Успешный перевод
      } catch (e) {
        emit(BankError(e.toString()));
      }
    });
  }
}
