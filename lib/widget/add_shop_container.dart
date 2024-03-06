import 'package:flutter/material.dart';

class AddShopContainer extends StatelessWidget {
  const AddShopContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final addTitle = TextEditingController();
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Text(
        'Add a new shop!',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      content: TextField(
        cursorColor: Theme.of(context).colorScheme.onPrimary,
          textAlign: TextAlign.center,
          controller: addTitle,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: 'Shop name...',
            hintStyle: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      actions: [
        IconButton(
          onPressed: () => Navigator.of(context).pop(addTitle.text),
          icon: const Icon(
            Icons.check,
          ),
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon:const Icon(
            Icons.close,
          ),
          color: Theme.of(context).colorScheme.secondary,
        ),
      ],
    );
  }
}
