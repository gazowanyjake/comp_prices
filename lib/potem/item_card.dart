import 'package:flutter/material.dart';

import 'potemitem_screen.dart';

class ItemCard extends StatelessWidget {
  ItemCard(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
        color: const Color(0xFF977390),
        child: Center(
          child: Text(title),
        ),
    );
  }
}
