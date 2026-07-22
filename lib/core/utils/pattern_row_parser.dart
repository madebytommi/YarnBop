import '../../features/pattern_rows/data/models/pattern_row.dart';

/// Parses raw text into a list of [PatternRow] instances.
///
/// Splits the input [rawText] by line breaks (`\n` or `\r\n`), filters out
/// empty or whitespace-only lines, and assigns 1-indexed sequential row numbers.
///
/// Returns an empty list if [rawText] is null, empty, or whitespace-only.
List<PatternRow> parsePatternRows(String? rawText) {
  // Basic error handling for null, empty, or whitespace-only input
  if (rawText == null || rawText.trim().isEmpty) {
    return [];
  }

  // Split by unix (\n) or windows (\r\n) line breaks
  final lines = rawText.split(RegExp(r'\r?\n'));
  final List<PatternRow> rows = [];
  int currentRowNumber = 1;

  for (final line in lines) {
    final trimmed = line.trim();
    // Ignore empty or whitespace-only lines
    if (trimmed.isNotEmpty) {
      rows.add(
        PatternRow(
          rowNumber: currentRowNumber,
          instruction: trimmed,
          isCompleted: false,
        ),
      );
      currentRowNumber++;
    }
  }

  return rows;
}
