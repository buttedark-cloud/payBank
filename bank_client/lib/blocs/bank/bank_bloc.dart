import 'package:bank_client/data/models/account.dart';
import 'package:bank_client/data/models/transfer_result.dart';
import 'package:bank_client/data/services/bank_api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Подключаем наши дочерние файлы событий и состояний
part 'bank_event.dart';
part 'bank_state.dart';

class BankBloc extends Bloc<BankEvent, BankState> {
  final BankApiService _apiService;

  // Убираем слово 'Exception:' из текста ошибки
  String _clean(Object e) => e.toString().replaceFirst('Exception: ', '');

  // Обязательный конструктор, который мы случайно затерли!
  BankBloc(this._apiService) : super(BankInitial()) {
    // 1. Обработка события регистрации
    on<RegisterUserEvent>((event, emit) async {
      emit(BankLoading()); // Показываем лоадер
      try {
        final result = await _apiService.registerUser(event.name, event.passportNumber);
        emit(BankAccountSuccess(result)); // Успех! Передаем данные
      } catch (e) {
        emit(BankError(_clean(e)));
      }
    });

    // 2. Обработка события получения счета/карты
    on<GetAccountEvent>((event, emit) async {
      emit(BankLoading());
      try {
        final result = await _apiService.getAccount(event.cardNumber);
        emit(BankAccountSuccess(result));
      } catch (e) {
        emit(BankError(_clean(e)));
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
        emit(BankError(_clean(e)));
      }
    });
  }
}
