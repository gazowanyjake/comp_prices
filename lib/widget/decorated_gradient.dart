import 'package:flutter/material.dart';

class DecoratedGradient extends StatelessWidget {
  DecoratedGradient({required this.widget, super.key});
  final Widget widget;
  @override
  Widget build(BuildContext context) {
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
      child: widget,
    );
  }
}
