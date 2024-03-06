import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:wyniki/model/product_model.dart';
import '../provider/brain.dart';

class SearchListContainer extends StatefulWidget {
  SearchListContainer({
    super.key,
  });

  @override
  State<SearchListContainer> createState() => _SearchListContainerState();
}

class _SearchListContainerState extends State<SearchListContainer> {
  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context, listen: false);
    return TextField(
      style: TextStyle(
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      cursorColor: Theme.of(context).colorScheme.onPrimary,
      controller: brainProvider.searchingController,
      onChanged: (value) {
        print(value);
        brainProvider.searchListGenerator(
          value,
        );
      },
      decoration: InputDecoration(
        prefixIcon: IconButton(
          onPressed: () {
            brainProvider.searchingController.clear();
            brainProvider.stopSearching();
            FocusScope.of(context).unfocus();
          },
          icon: Icon(
            Icons.clear,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        suffixIcon: Icon(
          Icons.search,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
