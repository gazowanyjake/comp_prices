import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:geolocator/geolocator.dart';

import '../provider/brain.dart';
import '../widget/panel_content.dart';
import '../widget/add_shop_container.dart';
import '../widget/pin_container.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});
  static const routeName = '/map-screen';

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final brainProvider = Provider.of<Brain>(context, listen: false);
    brainProvider.searchBarLoading = true;
    // brainProvider.getLocationPermission();
    brainProvider.checkInternetConnection();
    brainProvider.getCurrentLocation();
    // brainProvider.clearBox();
    if (brainProvider.loadedList.isEmpty) {
      brainProvider.loadMarkers();
      print('markers loaded');
    } else {
      brainProvider.allProductsListGenerator();
    }
  }

  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context);
    final _suggestionsList = brainProvider.allProductsListNoDuplicatesSearchBar
        .map(
          (e) => e.title,
        )
        .toList();
    return brainProvider.loadingMarkers
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            bottomSheet: brainProvider.isInternetOn
                ? Container(
                    height: 0,
                  )
                : Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 80,
                    color: Colors.black,
                    child: const Text(
                      'No internet Connection',
                      textAlign: TextAlign.center,
                    ),
                  ),
            extendBodyBehindAppBar: true,
            appBar: EasySearchBar(
              searchClearIconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              searchCursorColor: Theme.of(context).colorScheme.onPrimary,
              foregroundColor: Theme.of(context).colorScheme.primary,
              searchBackgroundColor: Theme.of(context).colorScheme.primary,
              suggestionBackgroundColor: Theme.of(context).colorScheme.primary,
              searchTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              searchBackIconTheme:
                  IconThemeData(color: Theme.of(context).colorScheme.secondary),
              suggestions: _suggestionsList,
              suggestionTextStyle:
                  TextStyle(color: Theme.of(context).colorScheme.onPrimary),
              leading: IconButton(
                onPressed: () {
                  setState(brainProvider.readyToAddMarker);
                },
                icon: Icon(
                  brainProvider.readyToAddMarkerHandler
                      ? Icons.add_location_alt
                      : Icons.add_location_alt_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              isFloating: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(''),
              onSearch: (pickedProduct) => null,
              onSuggestionTap: (item) {
                brainProvider.showItemPriceMap(item);
              },
              actions: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      brainProvider.itemSearchPick = false;
                    });
                  },
                  icon: const Icon(
                    Icons.clear,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                FlutterMap(
                  mapController: brainProvider.mapController,
                  options: MapOptions(
                    onMapReady: () {
                      brainProvider.showProductOnMap
                          ? brainProvider.mapController.move(
                              LatLng(
                                brainProvider.markerCords.latitude,
                                brainProvider.markerCords.longitude,
                              ),
                              18,
                            )
                          : const SizedBox();
                    },
                    interactiveFlags:
                        InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                    center: LatLng(52.237049, 21.017532),
                    zoom: 11,
                    maxZoom: 18,
                    onTap: (tapPosition, point) {
                      if (brainProvider.readyToAddMarkerHandler) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              const AddShopContainer(),
                        ).then(
                          (shopName) {
                            brainProvider.addMarkerBoxTemp(
                              tapPosition,
                              point,
                              shopName as String,
                            );
                          },
                        );

                        // brainProvider.addMarker(tapPosition, point, title);
                      }
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    MarkerClusterLayerWidget(
                      options: MarkerClusterLayerOptions(
                        maxClusterRadius: 45,
                        size: const Size(40, 40),
                        anchor: AnchorPos.align(AnchorAlign.center),
                        fitBoundsOptions: const FitBoundsOptions(
                          padding: EdgeInsets.all(50),
                          maxZoom: 15,
                        ),
                        markers: brainProvider.loadedList
                            .map(
                              (e) => Marker(
                                width: 80,
                                height: 80,
                                point: LatLng(e.latitude, e.longitude),
                                builder: (_) => PinContainer(
                                  title: e.title,
                                  pinCords: LatLng(e.latitude, e.longitude),
                                ),
                              ),
                            )
                            .toList(),
                        builder: (context, markers) {
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            child: Center(
                              child: Text(
                                markers.length.toString(),
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // MarkerLayer(
                    //   markers: brainProvider.loadedList
                    //       .map(
                    //         (e) => Marker(
                    //           width: 80,
                    //           height: 80,
                    //           point: LatLng(e.latitude, e.longitude),
                    //           builder: (_) => PinContainer(
                    //             title: e.title,
                    //             pinCords: LatLng(e.latitude, e.longitude),
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),

                    //   //  brainProvider.markersList,
                    // ),
                    MarkerLayer(
                      markers: [brainProvider.userLocation],
                    )
                  ],
                ),
                Positioned(
                  right: 5,
                  bottom: 5,
                  child: FloatingActionButton(
                    child: Icon(
                      Icons.location_history,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      if (brainProvider.isLocationKnown == false) {
                        return;
                      }
                      brainProvider.mapController.move(
                        LatLng(
                          brainProvider.position.latitude,
                          brainProvider.position.longitude,
                        ),
                        15,
                      );
                    },
                  ),
                ),
                SlidingUpPanel(
                  backdropOpacity: 0,
                  backdropEnabled: true,
                  onPanelClosed: () => brainProvider.showProductOnMap = false,
                  defaultPanelState: brainProvider.showProductOnMap
                      ? PanelState.OPEN
                      : PanelState.CLOSED,
                  controller: brainProvider.pc,
                  minHeight: 0,
                  maxHeight: 200,
                  panel:const PanelContent(),
                ),
              ],
            ),
          );
  }
}
