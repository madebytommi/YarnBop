import 'package:hive/hive.dart';

part 'pattern_row.g.dart';

/// Data model representing a single row instruction in a crafting pattern.
@HiveType(typeId: 1)
class PatternRow extends HiveObject {
  @HiveField(0)
  final int rowNumber;

  @HiveField(1)
  final String instruction;

  @HiveField(2)
  final bool isCompleted;

  PatternRow({
    required this.rowNumber,
    required this.instruction,
    this.isCompleted = false,
  });

  PatternRow copyWith({
    int? rowNumber,
    String? instruction,
    bool? isCompleted,
  }) {
    return PatternRow(
      rowNumber: rowNumber ?? this.rowNumber,
      instruction: instruction ?? this.instruction,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
