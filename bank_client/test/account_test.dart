import 'package:flutter_test/flutter_test.dart';
import 'package:bank_client/data/models/account.dart';

void main() {
  group('Account.fromJson', () {
    test('читает все поля из JSON сервера', () {
      final account = Account.fromJson({'name': 'Тест', 'phone': '+79991112233', 'cardNumber': '4400-1111-2222-3333', 'balance': 500000});

      expect(account.name, 'Тест');
      expect(account.cardNumber, '4400-1111-2222-3333');
      expect(account.balance, 500000);
    });
    test('читает пустые поля из JSON сервера', () {
      final account = Account.fromJson({'name': '', 'phone': '', 'cardNumber': '', 'balance': 0});

      expect(account.name, '');
      expect(account.cardNumber, '');
      expect(account.balance, 0);
    });
    test('если в JSON нет name, имя будет пустой строкой', () {
      final account = Account.fromJson({'phone': '+79991112233', 'cardNumber': '4400-1111-2222-3333', 'balance': 500000});

      expect(account.name, '');
    });
  });
}
