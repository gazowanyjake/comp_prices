import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../provider/brain.dart';
import '../screens/tabs_screen.dart';
import '../widget/enable_location_prompt.dart';
import '../widget/gradient_background.dart';
import '../widget/product_tile.dart';
import '../widget/search_list_container.dart';
import './best_carts_screen.dart';
import '../widget/search_range_filter.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  @override
  void initState() {
    super.initState();
    Provider.of<Brain>(context, listen: false).isSearching = false;
    Provider.of<Brain>(context, listen: false).listInRangeLoading = true;
    Provider.of<Brain>(context, listen: false)
        .allProductsListInRangeGenerator();
  }

  final PanelController pcList = PanelController();

  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context, listen: false);

    String ifSearchTitle(int i) {
      return brainProvider.isSearching
          ? brainProvider.searchList[i].title
          : brainProvider.allProductsListNoDuplicatesInRange[i].title;
    }

    int ifSearchLenght() {
      return brainProvider.isSearching
          ? brainProvider.searchList.length
          : brainProvider.allProductsListNoDuplicatesInRange.length;
    }

    double ifSearchPrice(int i) {
      return brainProvider.isSearching
          ? brainProvider.searchList[i].price
          : brainProvider.allProductsListNoDuplicatesInRange[i].price;
    }

    LatLng ifSearchCords(int i) {
      return brainProvider.isSearching
          ? LatLng(
              brainProvider.searchList[i].latitude,
              brainProvider.searchList[i].longitude,
            )
          : LatLng(
              brainProvider.allProductsListNoDuplicatesInRange[i].latitude,
              brainProvider.allProductsListNoDuplicatesInRange[i].longitude,
            );
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: SearchListContainer(),
          leading: IconButton(
            onPressed: () {
              if (brainProvider.isLocationKnown == false) {
                return;
              }
              pcList.open();
              brainProvider.stopSearching();
              brainProvider.searchingController.clear();
              FocusScope.of(context).unfocus();
            },
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                brainProvider
                  ..cartGenerator()
                  ..calculateDistanceToShopsWithCartProducts()
                  ..checkDistanceToShops()
                  ..calculateBestCart();
                if (brainProvider.bestShopsListInRange.isEmpty) {
                  return;
                }
                Navigator.of(context).pushNamed(
                  BestCartsScreen.routeName,
                );
              },
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: brainProvider.isLocationKnown
            ? Stack(
                children: [
                  Consumer<Brain>(
                    builder: (context, value, _) => ListView.builder(
                      itemCount: ifSearchLenght(),
                      itemBuilder: (ctx, i) {
                        return GestureDetector(
                          onTap: () {
                            brainProvider
                              ..showProductOnMap = true
                              ..markerCords = ifSearchCords(i);
                            Navigator.of(context)
                                .pushReplacementNamed(TabsScreen.routeName);
                          },
                          child: Dismissible(
                            direction: DismissDirection.startToEnd,
                            confirmDismiss: (direction) async {
                              brainProvider.addToFavList(ifSearchTitle(i));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  content: const Text('Added to favorites!'),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              return false;
                            },
                            key: UniqueKey(),
                            child: ProductTile(
                              index: i,
                              title: ifSearchTitle(i),
                              price: ifSearchPrice(i),
                              isSearching: brainProvider.isSearching,
                              searchList: brainProvider.searchList,
                              isFavList: false,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SlidingUpPanel(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    header: IconButton(
                      onPressed: () {
                        pcList.close();
                      },
                      icon: Icon(
                        color: Theme.of(context).colorScheme.secondary,
                        Icons.close,
                      ),
                    ),
                    defaultPanelState: PanelState.CLOSED,
                    color: Theme.of(context).colorScheme.primary,
                    controller: pcList,
                    minHeight: 0,
                    maxHeight: 300,
                    panel: SearchRangeFilter(),
                  )
                ],
              )
            : const EnableLocationPrompt(),
      ),
    );
  }
}
