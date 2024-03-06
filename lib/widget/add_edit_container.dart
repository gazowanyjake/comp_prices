import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../model/shop_content.dart';
import '../provider/brain.dart';
import '../model/product_model.dart';

class AddEditContainer extends StatefulWidget {
  AddEditContainer({
    this.title = '',
    this.price = 0,
    required this.shopCords,
    required this.index,
    this.barCodeNumberTemp = 0,
    super.key,
  });
  String title;
  double price;
  LatLng shopCords;
  int index;
  int barCodeNumberTemp;

  @override
  State<AddEditContainer> createState() => _AddEditContainerState();
}

class _AddEditContainerState extends State<AddEditContainer> {
  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context);
    final regex = RegExp(r'\s+');
    final _formKey = GlobalKey<FormState>();
    var addEditProduct = ProductModel(
      title: widget.title,
      price: widget.price,
      latitude: widget.shopCords.latitude,
      longitude: widget.shopCords.longitude,
    );
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      actions: [
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                cursorColor: Colors.white,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintStyle: TextStyle(color: Colors.white),
                  hintText: 'Product title',
                ),
                initialValue: widget.title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'gib product name';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  addEditProduct = ProductModel(
                    title: newValue!,
                    price: addEditProduct.price,
                    latitude: addEditProduct.latitude,
                    longitude: addEditProduct.longitude,
                  );
                },
              ),
              TextFormField(
                style: TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Product price',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                inputFormatters: [
                  //4 max cyfry z przodu 2 po przecinku
                  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}(\,\d{0,2})?')),
                ],
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                initialValue: widget.price == 0 ? '' : widget.price.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'gib product price';
                  } 
                  return null;
                },
                onSaved: (newValue) {
                  addEditProduct = ProductModel(
                    title: addEditProduct.title.trim().replaceAll(regex, ' '),
                    price: double.parse(newValue!.replaceAll(',', '.')),
                    latitude: addEditProduct.latitude,
                    longitude: addEditProduct.longitude,
                    barCodeNumber: widget.barCodeNumberTemp,
                  );
                  print('${addEditProduct.title} ${widget.barCodeNumberTemp}');
                },
              ),
            ],
          ),
        ),
        IconButton(
          color: Theme.of(context).colorScheme.secondary,
          onPressed: () async {
            if (_formKey.currentState?.validate() == true &&
                widget.title != '' &&
                widget.price != 0) {
              _formKey.currentState!.save();
              print(
                  'test ${widget.shopCords} ${addEditProduct.title} ${addEditProduct.price} ');
              brainProvider.editProduct(
                widget.shopCords,
                widget.index,
                addEditProduct,
              );
              Navigator.of(context).pop();
            } else if (_formKey.currentState?.validate() == true &&
                widget.price == 0) {
              _formKey.currentState!.save();
              brainProvider.addProduct(
                widget.shopCords,
                widget.index,
                addEditProduct,
              );
              Navigator.of(context).pop();
            }
            brainProvider.searchBarLoading = true;
            brainProvider.allProductsListGenerator();
          },
          icon: Icon(
            Icons.check,
          ),
        ),
      ],
      title: widget.title == ''
          ? Text(
              'Add Product',
              style: TextStyle(color: Colors.white),
            )
          : Text(
              'Edit Product',
              style: TextStyle(color: Colors.white),
            ),
    );
  }
}
