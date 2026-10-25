import 'package:flutter_test/flutter_test.dart';
import 'package:bank_client/utils/money.dart';

void main() {
  group('formatKopecks', () {
    test('300030 копеек показываются как 3000.30', () {
      expect(formatKopecks(300030), '3000.30');
    });
    test('0 копеек показываются как 0.00', () {
      expect(formatKopecks(0), '0.00');
    });
    test('5 копеек показываются как 0.05', () {
      expect(formatKopecks(5), '0.05');
    });
  });

  group('rublesToKopecks', () {
    test('100.50 превращается в 10050 копеек', () {
      expect(rublesToKopecks('100.50'), 10050);
    });
    test('0.29 превращается в 29 копеек', () {
      expect(rublesToKopecks('0.29'), 29);
    });
    test('abc превращается в null', () {
      expect(rublesToKopecks('abc'), null);
    });
    test('запятая работает как точка', () {
      expect(rublesToKopecks('100,50'), 10050);
    });
  });
}
