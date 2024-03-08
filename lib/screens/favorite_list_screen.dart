import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';

import '../provider/brain.dart';
import '../screens/tabs_screen.dart';
import '../widget/enable_location_prompt.dart';
import '../widget/product_tile.dart';
import '../widget/search_list_container.dart';
import '../screens/best_carts_screen.dart';
import '../widget/gradient_background.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({super.key});

  @override
  State<FavoriteListScreen> createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  
  @override
  void initState() {
    super.initState();
    Provider.of<Brain>(context, listen: false).isSearching = false;
    Provider.of<Brain>(context, listen: false).isSearchingInFavorites = true;
    if (Provider.of<Brain>(context, listen: false).firstTimeFavList) {
      Provider.of<Brain>(context, listen: false).listInRangeLoading = true;
      Provider.of<Brain>(context, listen: false)
          .allProductsListInRangeGenerator();
      Provider.of<Brain>(context, listen: false).firstTimeFavList = false;
      print('first time loaded');
    }
  }

  @override
  void deactivate() {
    Provider.of<Brain>(context, listen: false).isSearchingInFavorites = false;
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context, listen: false);

    brainProvider.favoriteListGenerator();

    String ifSearchTitle(int i) {
      return brainProvider.isSearching
          ? brainProvider.searchList[i].title
          : brainProvider.favoriteListGenerated[i].title;
    }

    int ifSearchLenght() {
      return brainProvider.isSearching
          ? brainProvider.searchList.length
          : brainProvider.favoriteListGenerated.length;
    }

    LatLng ifSearchCords(int i) {
      return brainProvider.isSearching
          ? LatLng(brainProvider.searchList[i].latitude,
              brainProvider.searchList[i].longitude)
          : LatLng(brainProvider.favoriteListGenerated[i].latitude,
              brainProvider.favoriteListGenerated[i].longitude);
    }

    double ifSearchPrice(int i) {
      return brainProvider.isSearching
          ? brainProvider.searchList[i].price
          : brainProvider.favoriteListGenerated[i].price;
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: SearchListContainer(),
          leading: GestureDetector(
            onLongPress: brainProvider.removeAllFromCart,
            child: IconButton(
              onPressed: brainProvider.addAllToCart,
              icon: Icon(Icons.done_all),
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
              icon: const Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: brainProvider.isLocationKnown
            ? Consumer<Brain>(
                builder: (context, value, child) => ListView.builder(
                  itemCount: ifSearchLenght(),
                  itemBuilder: (ctx, i) {
                    return GestureDetector(
                      onTap: () {
                        brainProvider..showProductOnMap = true
                        ..markerCords = ifSearchCords(i);
                        Navigator.of(context)
                            .pushReplacementNamed(TabsScreen.routeName);
                      },
                      child: Dismissible(
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          brainProvider.removeFromFavList(
                            ifSearchTitle(
                              i,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              content: const Text('Removed from favorites!'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        key: UniqueKey(),
                        child: ProductTile(
                          index: i,
                          title: ifSearchTitle(i),
                          price: ifSearchPrice(i),
                          isSearching: brainProvider.isSearching,
                          searchList: brainProvider.searchList,
                          isFavList: true,
                        ),
                      ),
                    );
                  },
                ),
              )
            : const EnableLocationPrompt(),
      ),
    );
  }
}
