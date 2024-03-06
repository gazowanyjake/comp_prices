import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 1)
class ProductModel {
  ProductModel({
    required this.title,
    required this.price,
    required this.latitude,
    required this.longitude,
    this.inCart = false,
    this.isFavorite = false,
    this.isSeraching = false,
    this.distanceToProductInMeters = -1,
    this.barCodeNumber = 0,
    this.latitudeHive,
    this.longitudeHive,
  });
  @HiveField(0)
  String title;
  @HiveField(1)
  double price;
  @HiveField(2)
  double latitude;
  @HiveField(3)
  double longitude;
  @HiveField(4, defaultValue: false)
  bool inCart;
  @HiveField(5, defaultValue: false)
  bool isFavorite;
  @HiveField(6, defaultValue: false)
  bool isSeraching;
  @HiveField(7, defaultValue: -1)
  double distanceToProductInMeters;
  @HiveField(8, defaultValue: 0)
  int barCodeNumber;
  @HiveField(9)
  double? latitudeHive;
  @HiveField(10)
  double? longitudeHive;
}
