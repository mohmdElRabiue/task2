 // GENERATED CODE - DO NOT MODIFY BY HAND

part of 'translate.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TranslateAdapter extends TypeAdapter<Translate> {
  @override
  final int typeId = 1;

  @override
  Translate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Translate(
      lang_inPut: fields[0] as String,
      inPut: fields[1] as String,
      outPut: fields[2] as String,
      lang_output: fields[3] as String,
      translations: (fields[4] as Map).cast<String, String>(),
      matches: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Translate obj) {
    writer
      ..writeByte(6) // Total number of fields is 6
      ..writeByte(0)
      ..write(obj.lang_inPut)
      ..writeByte(1)
      ..write(obj.inPut)
      ..writeByte(2)
      ..write(obj.outPut)
      ..writeByte(3)
      ..write(obj.lang_output)
      ..writeByte(4)
      ..write(obj.translations)
      ..writeByte(5)
      ..write(obj.matches);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TranslateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}