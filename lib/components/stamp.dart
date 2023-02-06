import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class Stamp extends StatefulWidget {
  const Stamp({Key? key}) : super(key: key);

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Image.asset(
          'assets/stamp.png',
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        )
            .animate()
            .scaleX(begin: 4.0, end: 1.0, duration: 250.milliseconds)
            .then()
            .shake(hz: 4, curve: Curves.easeInOutCubic, duration: 500.milliseconds)
            .then()
            .shimmer();
      },
    );
  }
}
