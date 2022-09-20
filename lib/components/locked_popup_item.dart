import 'package:flutter/material.dart';

class LockedPopupItem extends PopupMenuItem {
  LockedPopupItem({this.onTap, required super.child});

  final VoidCallback? onTap;

  @override
  _PopupItemState createState() => _PopupItemState();
}

class _PopupItemState extends PopupMenuItemState {
  @override
  void handleTap() {
    widget.onTap?.call();
  }
}