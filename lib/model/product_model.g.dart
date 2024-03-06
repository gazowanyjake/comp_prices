// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 1;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      title: fields[0] as String,
      price: fields[1] as double,
      latitude: fields[2] as double,
      longitude: fields[3] as double,
      inCart: fields[4] == null ? false : fields[4] as bool,
      isFavorite: fields[5] == null ? false : fields[5] as bool,
      isSeraching: fields[6] == null ? false : fields[6] as bool,
      distanceToProductInMeters: fields[7] == null ? -1 : fields[7] as double,
      barCodeNumber: fields[8] == null ? 0 : fields[8] as int,
      latitudeHive: fields[9] as double?,
      longitudeHive: fields[10] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.latitude)
      ..writeByte(3)
      ..write(obj.longitude)
      ..writeByte(4)
      ..write(obj.inCart)
      ..writeByte(5)
      ..write(obj.isFavorite)
      ..writeByte(6)
      ..write(obj.isSeraching)
      ..writeByte(7)
      ..write(obj.distanceToProductInMeters)
      ..writeByte(8)
      ..write(obj.barCodeNumber)
      ..writeByte(9)
      ..write(obj.latitudeHive)
      ..writeByte(10)
      ..write(obj.longitudeHive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
