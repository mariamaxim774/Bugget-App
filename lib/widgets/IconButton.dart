import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;
  final double iconSize;
  final Color iconColor;

  const CustomIconButton({
    super.key,
    this.onPressed,
    required this.icon,
    required this.iconSize,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed ?? () {},
      icon: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}
