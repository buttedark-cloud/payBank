import 'package:bank_client/blocs/bank/bank_bloc.dart';
import 'package:bank_client/data/models/account.dart';
import 'package:bank_client/data/models/transfer_result.dart';
import 'package:bank_client/data/services/bank_api_service.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// «Подделка» сервиса: вместо настоящих запросов в интернет отвечает то, что прописано в тесте
class MockBankApiService extends Mock implements BankApiService {}

void main() {
  late MockBankApiService api;

  const account = Account(name: 'Тест', phone: '+79991112233', cardNumber: '4400-1111-2222-3333', balance: 500000);
  const transferResult = TransferResult(message: 'Перевод успешно выполнен!', senderNewBalance: 490000);

  setUp(() {
    api = MockBankApiService();
  });

  group('RegisterUserEvent', () {
    blocTest<BankBloc, BankState>(
      'успех: сначала Loading, потом AccountSuccess',
      build: () {
        when(() => api.registerUser(any(), any())).thenAnswer((_) async => account);
        return BankBloc(api);
      },
      act: (bloc) => bloc.add(const RegisterUserEvent(name: 'Тест', passportNumber: '+79991112233', cardNumber: '+79991112233')),
      expect: () => [BankLoading(), const BankAccountSuccess(account)],
    );

    blocTest<BankBloc, BankState>(
      'ошибка сервера: сначала Loading, потом Error с текстом сервера',
      build: () {
        when(() => api.registerUser(any(), any())).thenThrow(Exception('Укажите имя и номер телефона'));
        return BankBloc(api);
      },
      act: (bloc) => bloc.add(const RegisterUserEvent(name: '', passportNumber: '', cardNumber: '')),
      expect: () => [BankLoading(), const BankError('Укажите имя и номер телефона')],
    );

    blocTest<BankBloc, BankState>(
      'нет связи: Error с текстом про связь',
      build: () {
        when(() => api.registerUser(any(), any())).thenThrow(Exception('Нет связи с сервером. Попробуйте ещё раз'));
        return BankBloc(api);
      },
      act: (bloc) => bloc.add(const RegisterUserEvent(name: 'Тест', passportNumber: '+79991112233', cardNumber: '+79991112233')),
      expect: () => [BankLoading(), const BankError('Нет связи с сервером. Попробуйте ещё раз')],
    );
  });

  group('TransferMoneyEvent', () {
    blocTest<BankBloc, BankState>(
      'успех: сначала Loading, потом TransferSuccess с новым балансом',
      build: () {
        when(
          () => api.transferMoney(
            senderCardNumber: any(named: 'senderCardNumber'),
            recipientCardNumber: any(named: 'recipientCardNumber'),
            amount: any(named: 'amount'),
          ),
        ).thenAnswer((_) async => transferResult);
        return BankBloc(api);
      },
      act: (bloc) => bloc.add(
        const TransferMoneyEvent(senderCardNumber: '4400-1111-2222-3333', recipientCardNumber: '4400-9999-8888-7777', amount: 10000),
      ),
      expect: () => [BankLoading(), const BankTransferSuccess(transferResult)],
    );

    blocTest<BankBloc, BankState>(
      'ошибка: сначала Loading, потом Error "Недостаточно средств"',
      build: () {
        when(
          () => api.transferMoney(
            senderCardNumber: any(named: 'senderCardNumber'),
            recipientCardNumber: any(named: 'recipientCardNumber'),
            amount: any(named: 'amount'),
          ),
        ).thenThrow(Exception('Недостаточно средств на балансе'));
        return BankBloc(api);
      },
      act: (bloc) => bloc.add(
        const TransferMoneyEvent(senderCardNumber: '4400-1111-2222-3333', recipientCardNumber: '4400-9999-8888-7777', amount: 99999999),
      ),
      expect: () => [BankLoading(), const BankError('Недостаточно средств на балансе')],
    );
  });
}
