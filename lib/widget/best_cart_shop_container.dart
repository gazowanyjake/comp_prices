import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

import '../provider/brain.dart';
import '../screens/tabs_screen.dart';

class BestCartShopContainer extends StatelessWidget {
  BestCartShopContainer({
    required this.shopName,
    required this.cartPrice,
    required this.shopCords,
    required this.distanceToShop,
    super.key,
  });

  final String shopName;
  final double cartPrice;
  final LatLng shopCords;
  final double distanceToShop;

  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 20,
          color: Theme.of(context).colorScheme.secondary,
          child: Container(
            width: 240,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary,
            ),
            padding: EdgeInsets.all(30),
            margin: EdgeInsets.all(5),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(shopName),
                    Text('${cartPrice.toStringAsFixed(2)} PLN'),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text('distance to shop: ${(distanceToShop/1000).toStringAsFixed(2)} Km'),
              ],
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            brainProvider..showProductOnMap = true
            ..markerCords = shopCords;
            Navigator.of(context).pushNamedAndRemoveUntil(
              TabsScreen.routeName,
              (Route<dynamic> route) => false,
            );
          },
          icon: Icon(
            color: Theme.of(context).colorScheme.onPrimary,
            Icons.map_outlined,
            size: 50,
          ),
        ),
      ],
    );
  }
}
