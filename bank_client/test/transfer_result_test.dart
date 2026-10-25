import 'package:flutter_test/flutter_test.dart';
import 'package:bank_client/data/models/transfer_result.dart';

void main() {
  group('TransferResult.fromJson', () {
    test('читает все поля из JSON сервера', () {
      final transferResult = TransferResult.fromJson({'message': 'Перевод успешно выполнен', 'senderNewBalance': 400000});

      expect(transferResult.message, 'Перевод успешно выполнен');
      expect(transferResult.senderNewBalance, 400000);
    });
  });
}
