import 'package:flutter/material.dart';

extension ColorExtensions on Color {
  Color toLuminanceColor () {
    return this.computeLuminance() >= 0.5 ? Colors.black : Colors.white;
  }
}