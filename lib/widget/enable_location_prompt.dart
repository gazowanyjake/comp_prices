import 'package:flutter/material.dart';

class EnableLocationPrompt extends StatelessWidget {
  const EnableLocationPrompt({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            border:  Border.all(
              width: 2,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          height: 80,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'To use this screen enable location and restart app.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );
  }
}