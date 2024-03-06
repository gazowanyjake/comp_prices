import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

import '../provider/brain.dart';

class PinContainer extends StatelessWidget {
  PinContainer({
    required this.title,
    required this.pinCords,
  });
  final String title;
  final LatLng pinCords;

  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context);
    return Stack(
      children: [
        brainProvider.itemSearchPick
            ? Positioned(
                bottom: 20,
                child: FittedBox(
                  child: Text(
                    '${brainProvider.returnPriceOnMap(pinCords)} PLN',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              )
            : Container(),
        IconButton(
          color: Theme.of(context).colorScheme.primary,
          padding: EdgeInsets.zero,
          onPressed: () {
            brainProvider.mapController.move(
              LatLng(
                pinCords.latitude,
                pinCords.longitude,
              ),
              18,
            );
              brainProvider.openSlideUpPanel(pinCords);
          },
          icon: const Icon(
            Icons.pin_drop_outlined,
            size: 35,
          ),
        ),
      ],
    );
  }
}
