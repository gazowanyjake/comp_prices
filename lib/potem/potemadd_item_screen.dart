import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../provider/brain.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/addItemScreen';

  @override
  State<AddItemScreen> createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  @override
  Widget build(BuildContext context) {
    final itemId = ModalRoute.of(context)?.settings.arguments;
    int lol = (itemId ?? -1) as int;
    final brainProvider = Provider.of<Brain>(context);
    final addTitle = TextEditingController();
    final addDescription = TextEditingController();
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
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: (){
                // brainProvider.addStuff(addTitle.text, addDescription.text, lol);
                Navigator.of(context).pop(addTitle.text);
              },
              icon: Icon(Icons.done, color: Colors.white,),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.transparent,
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
                child: Container(
                  width: 100,
                  child: TextField(
                    
                    textAlign: TextAlign.center,
                    controller: addTitle,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "Item title...",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
                    textAlign: TextAlign.center,
                    controller: addDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      hintText: "Description...",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
