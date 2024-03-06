// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_content.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShopContentAdapter extends TypeAdapter<ShopContent> {
  @override
  final int typeId = 2;

  @override
  ShopContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShopContent(
      title: fields[0] as String,
      latitude: fields[1] as double,
      longitude: fields[2] as double,
      productsList: (fields[3] as List?)?.cast<ProductModel>(),
      bestCartPrice: fields[4] == null ? -1 : fields[4] as double,
      distanceToShopInMeters: fields[5] == null ? -1 : fields[5] as double,
      latitudeHive: fields[6] as double?,
      longitudeHive: fields[7] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ShopContent obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.productsList)
      ..writeByte(4)
      ..write(obj.bestCartPrice)
      ..writeByte(5)
      ..write(obj.distanceToShopInMeters)
      ..writeByte(6)
      ..write(obj.latitudeHive)
      ..writeByte(7)
      ..write(obj.longitudeHive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShopContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
