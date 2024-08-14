// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_source.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseSourceAdapter extends TypeAdapter<ExpenseSource> {
  @override
  final int typeId = 2;

  @override
  ExpenseSource read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseSource(
      id: fields[0] as int,
      name: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseSource obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseSourceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
