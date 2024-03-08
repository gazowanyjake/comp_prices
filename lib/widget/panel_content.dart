import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

import 'package:wyniki/model/shop_content.dart';
import '../provider/brain.dart';
import '../screens/shop_screen.dart';

class PanelContent extends StatefulWidget {
  const PanelContent({
    super.key,
  });

  @override
  State<PanelContent> createState() => _PanelContentState();
}

class _PanelContentState extends State<PanelContent> {
  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context);
    final shop = brainProvider.markerCords == LatLng(0, 0)
        ? ShopContent(latitude: 0, longitude: 0, productsList: [], title: '')
        : brainProvider.loadedList.firstWhere(
            (pin) =>
                LatLng(pin.latitude, pin.longitude) ==
                brainProvider.markerCords,
          );
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pushNamed(
                  ShopScreen.routeName,
                  arguments: shop,
                ),
                icon: Icon(
                  Icons.list,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                shop.title,
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          Text('Products in the shop : ${shop.productsList!.length}'),
          Text('Distance to shop : ${brainProvider.distanceToThisShop(
                LatLng(
                  shop.latitude,
                  shop.longitude,
                ),
              ).toStringAsFixed(2)} km'),
        ],
      ),
    );
  }
}
