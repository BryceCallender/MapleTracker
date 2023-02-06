import 'package:flutter/material.dart';
import 'package:maple_daily_tracker/components/user_profile_form.dart';
import 'package:maple_daily_tracker/styles.dart';

class UserProfileCard extends StatelessWidget {
  const UserProfileCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    VisualDensity density = themeData.visualDensity;
    return SizedBox(
      width: 280,
      height: 325 + density.vertical * 24,
      child: Stack(
        children: [
          Positioned.fill(
            child: AnimatedFractionalOffset(
              duration: Times.medium,
              curve: Curves.easeOut,
              begin: const Offset(0, -1),
              end: const Offset(0, 0),
              child: Container(
                padding: EdgeInsets.only(
                  left: Insets.lg,
                  right: Insets.lg,
                  top: Insets.med,
                ),
                decoration: BoxDecoration(
                  color: Color(0xFF41464b),
                  borderRadius:
                      const BorderRadius.all(Corners.lgRadius),
                ),
                child: const UserProfileForm(),
              ),
            ),
          ),
          _TopShadow(),
        ],
      ),
    );
  }
}

class _TopShadow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ClipRect(
        child: FractionalTranslation(
          translation: const Offset(0, -1),
          child: Container(
            decoration:
                BoxDecoration(color: Colors.greenAccent, boxShadow: Shadows.universal),
          ),
        ),
      ),
    );
  }
}

class AnimatedFractionalOffset extends StatelessWidget {
  const AnimatedFractionalOffset({
    required this.child,
    required this.duration,
    this.begin,
    required this.end,
    this.curve = Curves.easeOut,
    Key? key,
  }) : super(key: key);
  final Widget child;
  final Duration duration;
  final Offset? begin;
  final Offset end;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<Offset>(
      duration: duration,
      curve: curve,
      tween: Tween(begin: begin ?? end, end: end),
      builder: (context, offset, _) => FractionalTranslation(
        translation: offset,
        child: child,
      ),
    );
  }
}
