import 'package:flutter_test/flutter_test.dart';
import 'package:appp/shared/utils/mine_status.dart';

void main() {
  test('isMineDetectedStatus is case-insensitive', () {
    expect(isMineDetectedStatus('Mine détectée'), isTrue);
    expect(isMineDetectedStatus('mine détectée'), isTrue);
    expect(isMineDetectedStatus('MINE DETECTED'), isTrue);
    expect(isMineDetectedStatus('Aucune mine'), isFalse);
    expect(isMineDetectedStatus(null), isFalse);
    expect(
      isMineDetectedStatus('x', mineDetectedFlag: true),
      isTrue,
    );
  });
}
