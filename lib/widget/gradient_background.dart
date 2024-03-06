import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  GradientBackground({
    required this.child,
    super.key,
  });

  Widget child;
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF022121),
            Color(0xFF021D1D),
            Color(0xFF032929),
          ],
        ),
      ),
      child: child,
    );
  }
}
