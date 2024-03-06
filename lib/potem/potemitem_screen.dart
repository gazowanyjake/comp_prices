// ignore_for_file: cast_nullable_to_non_nullable, always_use_package_imports, public_member_api_docs, use_key_in_widget_constructors

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/brain.dart';

class ItemScreen extends StatelessWidget {
  static const routeName = '/itemScreen';

  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)?.settings.arguments as int;
    final brainProvider = Provider.of<Brain>(context);
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF704E2E),
            Color(0xFF003049),
          ],
        ),
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
              },
              icon: const Icon(
                Icons.edit,
                color: Colors.white,
              ),
            ),
          ],
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF977390),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 300,
              child: Center(
                child: Text(
                  brainProvider.itemsList[itemId].title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              brainProvider.itemsList[itemId].description,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 80,
            ),
            GestureDetector(
              onTap: () {
                brainProvider.deleteStuff(itemId);
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                height: 40,
                child: Center(
                  child: Text(
                    'returned',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
