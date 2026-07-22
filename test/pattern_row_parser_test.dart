import 'package:flutter_test/flutter_test.dart';
import 'package:yarnbop/core/utils/pattern_row_parser.dart';

void main() {
  group('parsePatternRows', () {
    test('returns empty list for null input', () {
      expect(parsePatternRows(null), isEmpty);
    });

    test('returns empty list for empty string input', () {
      expect(parsePatternRows(''), isEmpty);
    });

    test('returns empty list for whitespace-only input', () {
      expect(parsePatternRows('   \n  \t  \n '), isEmpty);
    });

    test('parses multi-line text and assigns sequential row numbers', () {
      const rawText = '''
Row 1: K2, P2 across
Row 2: P2, K2 across

Row 3: Repeat Row 1
      ''';

      final rows = parsePatternRows(rawText);

      expect(rows.length, equals(3));
      expect(rows[0].rowNumber, equals(1));
      expect(rows[0].instruction, equals('Row 1: K2, P2 across'));
      expect(rows[0].isCompleted, isFalse);

      expect(rows[1].rowNumber, equals(2));
      expect(rows[1].instruction, equals('Row 2: P2, K2 across'));

      expect(rows[2].rowNumber, equals(3));
      expect(rows[2].instruction, equals('Row 3: Repeat Row 1'));
    });
  });
}
