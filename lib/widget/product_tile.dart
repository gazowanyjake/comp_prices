import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wyniki/model/product_model.dart';

import '../provider/brain.dart';

class ProductTile extends StatefulWidget {
  ProductTile({
    required this.index,
    required this.title,
    required this.price,
    required this.isSearching,
    required this.searchList,
    required this.isFavList,
    super.key,
  });

  final int index;
  final String title;
  final double price;
  final bool isSearching;
  final List<ProductModel> searchList;
  final bool isFavList;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context, listen: false);
    bool ifSearchBoolFav(int i) {
      return brainProvider.isSearching
          ? brainProvider.searchList[i].inCart
          : brainProvider.favoriteListGenerated[i].inCart;
    }

    bool ifSearchBoolList(int i) {
      return brainProvider.isSearching
          ? brainProvider.searchList[i].inCart
          : brainProvider.allProductsListNoDuplicatesInRange[i].inCart;
    }

    return Card(
      shape: StadiumBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            50,
          ),
        ),
        tileColor: Theme.of(context).colorScheme.primary,
        textColor: Theme.of(context).colorScheme.onPrimary,
        trailing: SizedBox(
          width: 150,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                '${widget.price}< PLN',
              ),
              Checkbox(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2),
                ),
                side: MaterialStateBorderSide.resolveWith(
                  (states) => BorderSide(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                activeColor: Theme.of(context).colorScheme.onPrimary,
                checkColor: Theme.of(context).colorScheme.primary,
                value: widget.isFavList
                    ? ifSearchBoolFav(widget.index)
                    : ifSearchBoolList(widget.index),
                onChanged: (bool? value) {
                  if (value != null) {
                    widget.isSearching
                        ? setState(() {
                            brainProvider.searchList[widget.index].inCart =
                                value;
                            brainProvider.addToCart(
                              widget.title,
                              value,
                            );
                          })
                        : brainProvider.addToCart(
                            widget.title,
                            value,
                          );
                  }
                },
              ),
            ],
          ),
        ),
        title: Text(
          widget.title,
        ),
      ),
    );
  }
}
