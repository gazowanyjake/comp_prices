import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../model/shop_content.dart';
import '../provider/brain.dart';
import '../widget/add_edit_container.dart';
import '../widget/gradient_background.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  static const routeName = '/shop-screen';

  @override
  Widget build(BuildContext context) {
    final shopContent =
        ModalRoute.of(context)!.settings.arguments as ShopContent;
    print(shopContent.latitude);
    print(shopContent.longitude);
    final brainProvider = Provider.of<Brain>(context);
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () async {
                final barcode = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SimpleBarcodeScannerPage(),
                    ));
                print(barcode);
                String titleTemp =
                    brainProvider.searchProductByBarcode(barcode ?? '');
                showDialog<String>(
                  context: context,
                  builder: (context) => AddEditContainer(
                    title: titleTemp,
                    shopCords:
                        LatLng(shopContent.latitude, shopContent.longitude),
                    index: shopContent.productsList!.length,
                    barCodeNumberTemp: int.parse(barcode as String),
                  ),
                );
              },
              icon: Icon(
                Icons.barcode_reader,
              ),
            ),
            IconButton(
              onPressed: () => showDialog<void>(
                context: context,
                builder: (context) => AddEditContainer(
                  shopCords:
                      LatLng(shopContent.latitude, shopContent.longitude),
                  index: shopContent.productsList!.length,
                ),
              ),
              icon: Icon(
                Icons.add,
              ),
            ),
          ],
          title: Row(
            children: [
              Text(shopContent.title),
              IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  brainProvider.removeShopFromMap(
                    LatLng(
                      shopContent.latitude,
                      shopContent.longitude,
                    ),
                  );
                },
                icon: Icon(
                  Icons.delete_forever,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 300,
              height: 200,
              child: Image.network(
                'https://business.grivy.com/wp-content/uploads/2019/07/Store-personality-icons.png',
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: shopContent.productsList!.length,
                itemBuilder: (context, index) => Card(
                  color: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ExpansionTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        50,
                      ),
                    ),
                    key: ValueKey(
                      shopContent.productsList![index].title,
                    ),
                    title: Text(
                      shopContent.productsList![index].title,
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '${shopContent.productsList![index].price} PLN',
                      style: TextStyle(color: Colors.white),
                    ),
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () {
                              showDialog<void>(
                                context: context,
                                builder: (context) => AddEditContainer(
                                  title: shopContent.productsList![index].title,
                                  price: shopContent.productsList![index].price,
                                  shopCords: LatLng(
                                    shopContent.latitude,
                                    shopContent.longitude,
                                  ),
                                  index: index,
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                            ),
                          ),
                          IconButton(
                            color: Theme.of(context).colorScheme.secondary,
                            onPressed: () => brainProvider.deleteProduct(
                              LatLng(
                                shopContent.latitude,
                                shopContent.longitude,
                              ),
                              index,
                            ),
                            icon: Icon(
                              Icons.delete,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
