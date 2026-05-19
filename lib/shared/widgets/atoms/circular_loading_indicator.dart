import 'package:flutter/material.dart';

class CircularLoadingIndicator extends StatelessWidget {
  final double scale;
  const CircularLoadingIndicator({super.key, this.scale = 0.7});

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: const Center(child: CircularProgressIndicator(strokeWidth: 3.0)),
    );
  }
}
