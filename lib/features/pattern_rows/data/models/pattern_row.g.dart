// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pattern_row.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PatternRowAdapter extends TypeAdapter<PatternRow> {
  @override
  final int typeId = 1;

  @override
  PatternRow read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PatternRow(
      rowNumber: fields[0] as int,
      instruction: fields[1] as String,
      isCompleted: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PatternRow obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.rowNumber)
      ..writeByte(1)
      ..write(obj.instruction)
      ..writeByte(2)
      ..write(obj.isCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PatternRowAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
