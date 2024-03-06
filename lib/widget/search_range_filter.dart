import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/brain.dart';

class SearchRangeFilter extends StatefulWidget {
  SearchRangeFilter({super.key});

  @override
  State<SearchRangeFilter> createState() => _SearchRangeFilterState();
}

class _SearchRangeFilterState extends State<SearchRangeFilter> {
  @override
  Widget build(BuildContext context) {
    final brainProvider = Provider.of<Brain>(context, listen: false);
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 50, bottom: 100),
      color: Theme.of(context).colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('How far are you willing to go?'),
              IconButton(
                color: Theme.of(context).colorScheme.secondary,
                onPressed: brainProvider.addStuff,
                icon: const Icon(
                  Icons.send,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          RangeSlider(
            activeColor: Theme.of(context).colorScheme.onPrimary,
            inactiveColor: Theme.of(context).colorScheme.secondary,
            divisions: 30,
            max: 30,
            values: brainProvider.currentRangeValues,
            labels: RangeLabels(
              '${brainProvider.currentRangeValues.start.round()} Km',
              '${brainProvider.currentRangeValues.end.round()} Km',
            ),
            onChanged: (rangeValue) {
              setState(() {
                brainProvider.currentRangeValues =
                    RangeValues(0, rangeValue.end);
              });
              brainProvider..maxUserRange = rangeValue.end
              ..listInRangeLoading = true
              ..isRangeChanged = true
              ..allProductsListInRangeGenerator()
              ..adjustInCartItemsToRange();
            },
          ),
        ],
      ),
    );
  }
}
