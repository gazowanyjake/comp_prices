import 'package:hive/hive.dart';

import './product_model.dart';

part 'shop_content.g.dart';

@HiveType(typeId: 2)
class ShopContent {
  @HiveField(0)
  String title;
  @HiveField(1)
  double latitude;
  @HiveField(2)
  double longitude;
  @HiveField(3)
  List<ProductModel>? productsList;
  @HiveField(4, defaultValue: -1)
  double bestCartPrice;
  @HiveField(5, defaultValue: -1)
  double distanceToShopInMeters;
  @HiveField(6)
  double? latitudeHive;
  @HiveField(7)
  double? longitudeHive;

  ShopContent({
    required this.title,
    required this.latitude,
    required this.longitude,
    this.productsList,
    this.bestCartPrice = -1,
    this.distanceToShopInMeters = -1,
    this.latitudeHive,
    this.longitudeHive,
  });
}
