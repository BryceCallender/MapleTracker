import 'package:flutter/material.dart';

class Stamp extends StatefulWidget {
  const Stamp({Key? key}) : super(key: key);

  @override
  State<Stamp> createState() => _StampState();
}

class _StampState extends State<Stamp> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
      duration: const Duration(milliseconds: 500), vsync: this, value: 5.0)
  ..repeat();

  final int angle = -15;

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: AlwaysStoppedAnimation(angle / 360),
      child: ScaleTransition(
          scale: Tween<double>(begin: 4.0, end: 1.0).animate(
            CurvedAnimation(
              parent: _controller,
              curve: Curves.fastOutSlowIn,
            ),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Image.asset(
                'assets/stamp.png',
                width: constraints.maxWidth,
                height: constraints.maxHeight,
              );
            },
          )),
    );
  }
}
