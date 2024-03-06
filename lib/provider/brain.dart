import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:wyniki/model/shop_content.dart';
import 'dart:math';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wyniki/widget/best_cart_shop_container.dart';

import '../potem/item_model.dart';
import '../widget/pin_container.dart';
import '../model/product_model.dart';

class Brain with ChangeNotifier {
  final String _boxWithShops = 'shops';
  final String _boxWithFavorites = 'favorites';

  bool firstTimeFavList = true;

  List<ShopContent> loadedList = [];

  bool isLoading = false;

  final url = Uri.https(
    'owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
    'stuff.json',
  );
  Future<void> addStuff() async {
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final barcodesDatabase = [];
      for (var product in extractedData.entries) {
        barcodesDatabase.add(product.value['barcode']);
      }
      for (var i = 0; i < allProductsWithBarcode.length; i++) {
        if (barcodesDatabase
            .contains(allProductsWithBarcode[i].barCodeNumber)) {
          print('juz to mam kolego');
        } else {
          await http.post(
            url,
            headers: {
              'Item-title': 'stuff/json',
            },
            body: jsonEncode(
              {
                'title': allProductsWithBarcode[i].title,
                'barcode': allProductsWithBarcode[i].barCodeNumber,
              },
            ),
          );
        }
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> loadProducts() async {
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    List<ItemOwed> loadedData = [];
    for (var item in extractedData.entries) {
      loadedData.add(
        ItemOwed(
          id: item.key,
          title: item.value['title'] as String,
          description: item.value['description'] as String,
        ),
      );
    }
    itemsList = loadedData;
    notifyListeners();
  }

  Future<void> deleteStuff(int index) async {
    final editUrl = Uri.https(
      'owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
      'stuff/${itemsList[index].id}.json',
    );
    await http.delete(editUrl);
    itemsList.removeAt(index);
    notifyListeners();
  }

  Future<void> editStuff(
    String titleTemp,
    String descriptionTemp,
    int index,
  ) async {
    final editUrl = Uri.https(
      'owe-me-stuff-default-rtdb.europe-west1.firebasedatabase.app',
      'stuff/${itemsList[index].id}.json',
    );
    await http.patch(
      editUrl,
      body: jsonEncode({
        'title': titleTemp,
        'description': descriptionTemp,
      }),
    );
    itemsList[index] = ItemOwed(
      id: itemsList[index].id,
      title: titleTemp,
      description: descriptionTemp,
    );
    notifyListeners();
  }

  List<ItemOwed> itemsList = [];

  bool isInternetOn = true;

  Future<void> checkInternetConnection() async {
    try {
      final response = await http.get(url);
      if(isInternetOn == false){
      isInternetOn = true;
      print('jest internet znowu');
      notifyListeners();
      }
    } catch (error) {
      print('error: $error');
      isInternetOn = false;
      notifyListeners();
    }
  }
//
//
  // marker related functions
//
//
 
  bool readyToAddMarkerHandler = false;

  void readyToAddMarker() {
    readyToAddMarkerHandler = !readyToAddMarkerHandler;
  }

  PanelController pc = PanelController();

  LatLng markerCords = LatLng(0, 0);

  Future<void> addMarkerBoxTemp(_, LatLng pinCords, String title) async {
    if (loadedList.contains(
          ShopContent(
            title: title,
            latitude: pinCords.latitude,
            longitude: pinCords.longitude,
          ),
        ) ||
        title.isEmpty) {
      return;
    }
    var box = Hive.box<ShopContent>(_boxWithShops);
    await box.add(
      ShopContent(
        title: title,
        latitude: pinCords.latitude,
        longitude: pinCords.longitude,
        productsList: [],
      ),
    );
 
    searchBarLoading = true;
    readyToAddMarkerHandler = false;
    await loadMarkers();
    allProductsListGenerator();
    notifyListeners();
  }

  void removeShopFromMap(LatLng shopCords) {
    pc.close();
    markerCords = LatLng(0, 0);
    var box = Hive.box<ShopContent>(_boxWithShops);
    int boxShopIndex = box.values.toList().indexWhere(
          (element) =>
              LatLng(element.latitude, element.longitude) ==
              LatLng(
                shopCords.latitude,
                shopCords.longitude,
              ),
        );
    box.deleteAt(boxShopIndex);
    loadedList.removeWhere(
      (element) => LatLng(element.latitude, element.longitude) == shopCords,
    );
    allProductsListGenerator();
    notifyListeners();
  }

  bool loadingMarkers = false;

  Future<void> loadMarkers() async {
    loadedList = [];
    favoriteList = [];
    loadingMarkers = true;
    var box = await Hive.box<ShopContent>(_boxWithShops);
    var favBox = await Hive.box<String>(_boxWithFavorites);
    if (favBox.isEmpty) {
      favoriteList = [];
    } else {
      favoriteList = favBox.values.toList();
      favoriteListGenerator();
    }
    loadedList = box.values.toList();
    allProductsListGenerator();
    loadingMarkers = false;
    print('loaded list lenght ${loadedList.length}');
    print('favorites list lenght ${favoriteList.length}');
    notifyListeners();
  }

  List<ShopContent> addCordsToProductsAndShops(List<ShopContent> boxShopList) {
    List<ProductModel> productListTemp = [];
    for (var s = 0; s < boxShopList.length; s++) {
      if (boxShopList[s].productsList!.isEmpty) {
        return [];
      }
      // boxShopList[s].shopCords = LatLng(
      //   boxShopList[s].latitudeHive!,
      //   boxShopList[s].longitudeHive!,
      // );
      productListTemp = boxShopList[s].productsList!;
      // for (var p = 0; p < productListTemp.length; p++) {
      //   boxShopList[s].productsList![p].productCords = LatLng(
      //     productListTemp[p].latitudeHive!,
      //     productListTemp[p].longitudeHive!,
      //   );
      // }
    }
    return boxShopList;
  }

  // void addShopsFromBox(List<ShopContent> boxShopList) {
  //   for (var l = 0; l < boxShopList.length; l++) {
  //     shopsList.add(
  //       ShopContent(
  //         title: boxShopList[l].title,
  //         shopCords: LatLng(
  //           boxShopList[l].latitudeHive!,
  //           boxShopList[l].longitudeHive!,
  //         ),
  //         productsList: boxShopList[l].productsList,
  //       ),
  //     );
  //   }
  // }

  // Future<void> clearBox() async {
  //   var box = Hive.box<ShopContent>(_boxWithShops);
  //   box.clear();
  //   loadedList = [];
  //   markerCords = LatLng(0, 0);
  //   // shopsList = [];
  //   allProductsListOnMap = [];
  //   // markersList = [];
  //   searchBarLoading = true;
  //   allProductsListGenerator();
  //   notifyListeners();
  // }

  // void addMarker(_, LatLng pinCords, String title) {
  //   if (shopsList.contains(
  //         ShopContent(
  //           title: title,
  //           shopCords: pinCords,
  //         ),
  //       ) ||
  //       title.isEmpty) {
  //     return;
  //   }
  //   markerCords = pinCords;
  //   markersList.add(
  //     Marker(
  //       point: pinCords,
  //       builder: (ctx) {
  //         return PinContainer(
  //           title: title,
  //           pinCords: pinCords,
  //         );
  //       },
  //     ),
  //   );
  //   shopsList.add(
  //     ShopContent(
  //       title: title,
  //       shopCords: pinCords,
  //       productsList: [
  //         ProductModel(
  //           title: 'Kinderki',
  //           price: 6,
  //           productCords: pinCords,
  //         ),
  //         ProductModel(
  //           title: 'Miłosław Arcy Ipa',
  //           price: 7,
  //           productCords: pinCords,
  //         ),
  //         ProductModel(
  //           title: 'ser',
  //           price: 1,
  //           productCords: pinCords,
  //         ),
  //         ProductModel(
  //           title: 'mleko',
  //           price: 3,
  //           productCords: pinCords,
  //         ),
  //         ProductModel(
  //           title: 'cebula',
  //           price: 4,
  //           productCords: pinCords,
  //         ),
  //         ProductModel(
  //           title: 'marchew',
  //           price: 10,
  //           productCords: pinCords,
  //         ),
  //         ProductModel(
  //           title: 'dupa',
  //           price: 99,
  //           productCords: pinCords,
  //         ),
  //       ],
  //     ),
  //   );
  //   readyToAddMarkerHandler = false;
  //   notifyListeners();
  // }

  void openSlideUpPanel(LatLng pinCords) {
    markerCords = pinCords;
    notifyListeners();
    pc.open();
  }

  // Marker getMarkerFromIndex(int index) {
  //   return markersList[index];
  // }

  final mapController = MapController();
  //
  //
  // product add edit remove stuff
  //
  //
  void deleteProduct(LatLng cords, int productIndex) {
    var box = Hive.box<ShopContent>(_boxWithShops);
    int boxShopIndex = box.values.toList().indexWhere(
          (element) =>
              LatLng(element.latitude, element.longitude) ==
              LatLng(
                cords.latitude,
                cords.longitude,
              ),
        );
    ShopContent? tempShop = box.getAt(boxShopIndex);
    tempShop!.productsList!.removeAt(productIndex);
    box.putAt(boxShopIndex, tempShop);
    // final shop = loadedList.firstWhere((element) =>
    //     element.latitude == cords.latitude &&
    //     element.longitude == cords.longitude,);
    // shop.productsList!.removeAt(productIndex);
    allProductsListGenerator();
    notifyListeners();
  }

  void editProduct(LatLng cords, int productIndex, ProductModel newProduct) {
    var box = Hive.box<ShopContent>(_boxWithShops);
    int boxShopIndex = box.values.toList().indexWhere(
          (element) =>
              LatLng(element.latitude, element.longitude) ==
              LatLng(
                cords.latitude,
                cords.longitude,
              ),
        );
    ShopContent? tempShop = box.getAt(boxShopIndex);
    tempShop!.productsList!.removeAt(productIndex);
    tempShop.productsList!.insert(productIndex, newProduct);
    box.putAt(boxShopIndex, tempShop);
    // final shop = loadedList.firstWhere((element) =>
    //     element.latitude == cords.latitude &&
    //     element.longitude == cords.longitude);
    // shop.productsList!.removeAt(productIndex);
    // shop.productsList!.insert(productIndex, newProduct);
    notifyListeners();
  }

  void addProduct(LatLng cords, int productIndex, ProductModel newProduct) {
    var box = Hive.box<ShopContent>(_boxWithShops);
    int boxShopIndex = box.values.toList().indexWhere(
          (element) =>
              LatLng(element.latitude, element.longitude) ==
              LatLng(
                cords.latitude,
                cords.longitude,
              ),
        );
    ShopContent? tempShop = box.getAt(boxShopIndex);
    tempShop!.productsList!.insert(productIndex, newProduct);
    print(box.values.toList().length);
    box.putAt(boxShopIndex, tempShop);
    print(box.values.toList().length);
    // final shop = loadedList.firstWhere(
    //   (element) =>
    //       element.latitude == cords.latitude &&
    //       element.longitude == cords.longitude,
    // );
    // // print('newprodcords ${newProduct.productCords}');
    // shop.productsList!.insert(
    //   productIndex,
    //   newProduct,
    // );
    // d
    notifyListeners();
  }

  //
  //
  //
  // all about the product list's
  //
  //
  //
  List<ProductModel> allProductsListOnMap = [];
  List<ProductModel> allProductsListInRange = [];
  List<ProductModel> allProductsListNoDuplicatesSearchBar = [];
  List<ProductModel> allProductsListNoDuplicatesInRange = [];

  List<ProductModel> allProductsWithBarcode = [];

  void generateProductsWithBarCodes() {
    allProductsWithBarcode = [];
    for (var i = 0; i < allProductsListNoDuplicatesSearchBar.length; i++) {
      if (allProductsListNoDuplicatesSearchBar[i].barCodeNumber != 0) {
        print('added product with barcode');
        allProductsWithBarcode.add(allProductsListNoDuplicatesSearchBar[i]);
      }
    }
  }

  String searchProductByBarcode(var barcode) {
    int barcodeTemp = int.parse(barcode as String);
    for (var b = 0; b < allProductsWithBarcode.length; b++) {
      if (barcodeTemp == allProductsWithBarcode[b].barCodeNumber) {
        return allProductsWithBarcode[b].title;
      }
    }
    return '';
  }

  void allProductsListGenerator() {
    // print('shops list lenght ${loadedList.length}');
    allProductsListOnMap = [];
    print('loaded list productslist ${loadedList[0].productsList!.length}');
    for (var i = 0; i < loadedList.length; i++) {
      allProductsListOnMap += loadedList[i].productsList!;
    }
    // print('allproducts list lenght ${allProductsListOnMap.length}');
    allProductsListNoDuplicatesGeneratorFunction(
      allProductsListOnMap,
    );
    generateProductsWithBarCodes();
  }

  bool isRangeChanged = false;

  void allProductsListInRangeGenerator() {
    distanceToNearestProduct();
    List<ProductModel> allProductsListTemp = [];
    for (var d = 0; d < allProductsListOnMap.length; d++) {
      if ((allProductsListOnMap[d].distanceToProductInMeters / 1000) <
          maxUserRange) {
        allProductsListTemp.add(allProductsListOnMap[d]);
      }
    }
    allProductsListInRange = allProductsListTemp;
    allProductsListNoDuplicatesGeneratorFunction(
      allProductsListInRange,
    );
    if (isRangeChanged) {
      notifyListeners();
      isRangeChanged = false;
    }
  }

  bool searchBarLoading = false;
  bool listInRangeLoading = false;

  void allProductsListNoDuplicatesGeneratorFunction(
    List<ProductModel> allProducts,
  ) {
    List<String> tempPorductsNoDuplicates = [];
    List<ProductModel> noDuplicates = [];
    tempPorductsNoDuplicates = allProducts
        .map(
          (e) => e.title,
        )
        .toSet()
        .toList();
    for (var t = 0; t < tempPorductsNoDuplicates.length; t++) {
      String tempProdTitle = tempPorductsNoDuplicates[t];
      double tempProdPrice = allProducts.map((d) {
        if (tempProdTitle != d.title) {
          return 9999999.99;
        } else {
          return d.price;
        }
      }).reduce(min);
      ProductModel cheapestProd = allProducts.firstWhere((element) =>
          element.title == tempProdTitle && element.price == tempProdPrice);
      noDuplicates.add(cheapestProd);
    }
    if (searchBarLoading) {
      allProductsListNoDuplicatesSearchBar = noDuplicates;
      searchBarLoading = false;
    } else if (listInRangeLoading) {
      allProductsListNoDuplicatesInRange = noDuplicates;
      listInRangeLoading = false;
    }
  }

  List<String> favoriteList = [];

  void addToFavList(String productTitle) {
    if (favoriteList.contains(productTitle)) {
      return;
    }
    favoriteList.add(productTitle);
    var favBox = Hive.box<String>(_boxWithFavorites);
    favBox.add(productTitle);
    notifyListeners();
  }

  void removeFromFavList(String productTitle) {
    if (favoriteList.contains(productTitle)) {
      favoriteList.remove(productTitle);
      var favBox = Hive.box<String>(_boxWithFavorites);
      int favIndex = favBox.values
          .toList()
          .indexWhere((element) => element == productTitle);
      favBox.deleteAt(favIndex);
      favoriteListGenerator();
    }
  }

  List<ProductModel> favoriteListGenerated = [];

  void favoriteListGenerator() {
    favoriteListGenerated = [];
    for (var i = 0; i < allProductsListNoDuplicatesInRange.length; i++) {
      if (favoriteList.contains(allProductsListNoDuplicatesInRange[i].title)) {
        favoriteListGenerated.add(allProductsListNoDuplicatesInRange[i]);
      }
    }
    print('lista ulubionych ${favoriteListGenerated.length}');
  }

  //function to add or remove all items from cart in favorites tab
  void addAllRemoveAllFunction(bool changeFrom, bool changeTo) {
    for (var i = 0; i < favoriteListGenerated.length; i++) {
      if (favoriteListGenerated[i].inCart == changeFrom) {
        favoriteListGenerated[i].inCart = changeTo;
        for (var e = 0; e < allProductsListInRange.length; e++) {
          if (allProductsListInRange[e].title ==
              favoriteListGenerated[i].title) {
            allProductsListInRange[e].inCart = changeTo;
          }
        }
      }
    }
  }

  void addAllToCart() {
    lastIsInCartValue = true;
    addAllRemoveAllFunction(false, true);
    notifyListeners();
  }

  void removeAllFromCart() {
    lastIsInCartValue = false;
    addAllRemoveAllFunction(true, false);
    notifyListeners();
  }

  //
  //
  // all about the search
  //
  //

  List<ProductModel> searchList = [];

  bool isSearching = false;

  bool isSearchingInFavorites = false;

  final searchingController = TextEditingController();

  void stopSearching() {
    isSearching = false;
    notifyListeners();
  }

  void searchListGenerator(String searchTitle) {
    isSearching = true;
    searchList = [];
    if (allProductsListNoDuplicatesInRange.isEmpty) {
      return;
    }
    if (isSearchingInFavorites) {
      for (var j = 0; j < favoriteListGenerated.length; j++) {
        if (favoriteListGenerated[j].title.contains(searchTitle)) {
          searchList.add(
            favoriteListGenerated[j],
          );
        }
      }
    } else {
      for (var i = 0; i < allProductsListNoDuplicatesInRange.length; i++) {
        if (allProductsListNoDuplicatesInRange[i].title.contains(searchTitle)) {
          searchList.add(
            allProductsListNoDuplicatesInRange[i],
          );
        }
      }
    }
    notifyListeners();
  }
  //
  //
  // all about the cart
  //
  //

  void addToCart(String productTitle, bool isInCart) {
    lastIsInCartValue = isInCart;
    for (var e = 0; e < allProductsListInRange.length; e++) {
      if (allProductsListInRange[e].title == productTitle) {
        allProductsListInRange[e].inCart = isInCart;
      }
    }
    notifyListeners();
  }

  bool lastIsInCartValue = false;

  void adjustInCartItemsToRange() {
    for (var f = 0; f < allProductsListInRange.length; f++) {
      if (allProductsListInRange[f].inCart == lastIsInCartValue) {
        for (var s = 0; s < allProductsListInRange.length; s++) {
          if (allProductsListInRange[f].title ==
              allProductsListInRange[s].title) {
            allProductsListInRange[s].inCart = lastIsInCartValue;
          }
        }
      }
    }
    notifyListeners();
  }

  bool showProductOnMap = false;

  String productPickedOnSearchBar = '';

  List<ProductModel> itemsInCart = [];

  List<ShopContent> shopsWithProductsInCart = [];

  void cartGenerator() {
    shopsWithProductsInCart = [];
    itemsInCart = [];
    List<String> itemsInCartTitles = [];
    itemsInCart = allProductsListNoDuplicatesInRange
        .where((product) => product.inCart == true)
        .toList();
    if (itemsInCart.isEmpty) {
      return;
    }
    itemsInCartTitles = itemsInCart
        .map(
          (product) => product.title,
        )
        .toList();
    for (var s = 0; s < loadedList.length; s++) {
      List<String> temp =
          loadedList[s].productsList!.map((e) => e.title).toList();
      var set = Set.of(temp);
      if (set.containsAll(itemsInCartTitles)) {
        shopsWithProductsInCart.add(loadedList[s]);
      }
    }
  }

  double bestCart = 0;
  LatLng bestCartCords = LatLng(0.0, 0.0);
  String bestShopName = '';
  double bestShopDistance = -1;
  bool bestCartCalculatingBool = false;

  double secondBestCart = 0;
  LatLng secondBestCartCords = LatLng(0.0, 0.0);
  String secondBestShopName = '';
  double secondBestShopDistance = -1;
  bool secondBestCartCalculatingBool = false;

  List<ShopContent> bestShopsListInRange = [];

  void calculateBestCartFunction() {
    double currentBestCart = 0;
    LatLng currentBestCartCords = LatLng(0.0, 0.0);
    String currentBestShopName = '';
    double currentBestDistanceToShop = -1;
    if (shopsListInRange.length == 0) {
      return;
    }
    double bestCartTemp = 0;
    LatLng bestCartCordsTemp = LatLng(0.0, 0.0);
    for (var i = 0; i < shopsListInRange.length; i++) {
      for (var t = 0; t < itemsInCart.length; t++) {
        bestCartTemp += shopsListInRange[i]
            .productsList!
            .firstWhere((element) => element.title == itemsInCart[t].title)
            .price;
        bestCartCordsTemp =
            LatLng(shopsListInRange[i].latitude, shopsListInRange[i].longitude);
            print(bestCartTemp);
      }
      if (currentBestCart == 0) {
        currentBestCart = bestCartTemp;
        currentBestCartCords = bestCartCordsTemp;
      }
      if (bestCartTemp < currentBestCart) {
        currentBestCart = bestCartTemp;
        currentBestCartCords = bestCartCordsTemp;
      } else {
        currentBestCart = currentBestCart;
      }
      bestCartTemp = 0;
    }
    currentBestShopName = shopsListInRange
        .firstWhere((element) =>
            LatLng(element.latitude, element.longitude) == currentBestCartCords)
        .title;
    currentBestDistanceToShop = shopsListInRange
        .firstWhere((element) =>
            LatLng(element.latitude, element.longitude) == currentBestCartCords)
        .distanceToShopInMeters;
    bestShopsListInRange.add(
      ShopContent(
        title: currentBestShopName,
        latitude: currentBestCartCords.latitude,
        longitude: currentBestCartCords.longitude,
        bestCartPrice: currentBestCart,
        distanceToShopInMeters: currentBestDistanceToShop,
      ),
    );
    shopsListInRange.removeWhere((element) =>
        LatLng(element.latitude, element.longitude) == currentBestCartCords);
    notifyListeners();
  }

  int shopsInRangeTemp = 0;

  void calculateBestCart() {
    bestShopsListInRange = [];
    shopsInRangeTemp = shopsListInRange.length;
    for (var i = 0; i < shopsInRangeTemp; i++) {
      calculateBestCartFunction();
    }
  }

  void removeAllItemsFromCart() {
    for (var i = 0; i < allProductsListNoDuplicatesInRange.length; i++) {
      allProductsListNoDuplicatesInRange[i].inCart = false;
    }
    bestCart = 0;
    bestShopName = '';
    bestCartCords = LatLng(0.0, 0.0);
    notifyListeners();
  }

  // pick item from search list and display on map
  bool itemSearchPick = false;

  void showItemPriceMap(String item) {
    productPickedOnSearchBar = item;
    itemSearchPick = true;
    notifyListeners();
  }

  double returnPriceOnMap(LatLng shopCords) {
    final myShop = loadedList.firstWhere(
      (element) => LatLng(element.latitude, element.longitude) == shopCords,
    );
    final myProductsTitles = myShop.productsList!.map((e) => e.title).toList();
    final myProductBool = myProductsTitles.contains(productPickedOnSearchBar);
    if (myProductBool) {
      return myShop.productsList!
          .firstWhere(
            (element) => element.title == productPickedOnSearchBar,
          )
          .price;
    } else {
      return 0;
    }
  }

  //
  //
  // user location related stufff
  //
  //

  late LocationPermission permission;

  Future<void> getLocationPermission() async {
    permission = await Geolocator.requestPermission();
    print(permission);
  }

  late Position position;

  Marker userLocation = Marker(
    point: LatLng(0, 0),
    builder: (context) => Icon(
      Icons.person,
    ),
  );

  late bool isLocationKnown;

  Future<void> getCurrentLocation() async {
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      isLocationKnown = false;
      return;
    }
    isLocationKnown = true;
    position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    userLocation = Marker(
      point: LatLng(position.latitude, position.longitude),
      builder: (context) => Icon(
        Icons.person,
      ),
    );
    notifyListeners();
    print('$position pozycja');
  }

  //
  //
  // user distance to shop/product
  //
  //
  RangeValues currentRangeValues = RangeValues(0, 20);

  void calculateDistanceToShopsWithCartProducts() {
    for (var i = 0; i < shopsWithProductsInCart.length; i++) {
      double distanceInMetersTemp = Geolocator.distanceBetween(
        userLocation.point.latitude,
        userLocation.point.longitude,
        shopsWithProductsInCart[i].latitude,
        shopsWithProductsInCart[i].longitude,
      );
      shopsWithProductsInCart[i].distanceToShopInMeters = distanceInMetersTemp;
    }
  }

  double maxUserRange = 30;

  List<ShopContent> shopsListInRange = [];

  double distanceToThisShop(LatLng shopCords) {
    if (isLocationKnown == false) {
      return 0;
    }
    return (Geolocator.distanceBetween(
          userLocation.point.latitude,
          userLocation.point.longitude,
          shopCords.latitude,
          shopCords.longitude,
        ) /
        1000);
  }

  void checkDistanceToShops() {
    List<ShopContent> shopsListInRangeTemp = [];
    for (var d = 0; d < shopsWithProductsInCart.length; d++) {
      if (shopsWithProductsInCart[d].distanceToShopInMeters / 1000 <
          maxUserRange) {
        shopsListInRangeTemp.add(shopsWithProductsInCart[d]);
      }
    }
    shopsListInRange = shopsListInRangeTemp;
    print('shoplistinrange.lenght ${shopsListInRange.length}');
  }

  void distanceToNearestProduct() {
    print('distanceToNearestProduct');
    print('allproductslistonmap.lenght ${allProductsListOnMap.length}');
    for (var d = 0; d < allProductsListOnMap.length; d++) {
      double distanceInMetersTemp = Geolocator.distanceBetween(
        userLocation.point.latitude,
        userLocation.point.longitude,
        allProductsListOnMap[d].latitude,
        allProductsListOnMap[d].longitude,
      );
      allProductsListOnMap[d].distanceToProductInMeters = distanceInMetersTemp;
    }
  }
}
