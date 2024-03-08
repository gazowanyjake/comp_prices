import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

import '../widget/best_cart_shop_container.dart';
import '../provider/brain.dart';
import '../widget/gradient_background.dart';

class BestCartsScreen extends StatelessWidget {
  const BestCartsScreen({super.key});
  static const routeName = '/best-carts-screen';

  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context);
    return GradientBackground(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          title: Text(
            'Cheapest cart\'s near you!',
          ),
        ),
        body: brainProvider.bestShopsListInRange.isEmpty
            ? Center(
                child: Text(
                  'No shops aviable in your range :(',
                ),
              )
            : ListView.builder(
                itemCount: brainProvider.bestShopsListInRange.length,
                itemBuilder: (context, index) {
                  return BestCartShopContainer(
                    shopName: brainProvider.bestShopsListInRange[index].title,
                    cartPrice:
                        brainProvider.bestShopsListInRange[index].bestCartPrice,
                    shopCords: LatLng(
                      brainProvider.bestShopsListInRange[index].latitude,
                      brainProvider.bestShopsListInRange[index].longitude,
                    ),
                    distanceToShop: brainProvider
                        .bestShopsListInRange[index].distanceToShopInMeters,
                  );
                },
              ),
      ),
    );
  }
}
