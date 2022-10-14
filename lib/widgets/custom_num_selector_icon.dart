import 'package:flutter/material.dart';

class CustomNumSelectorIcon extends StatelessWidget {

  final IconData icon;
  final double opacity;

  const CustomNumSelectorIcon({
    super.key,
    required this.icon,
    required this.opacity 
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Icon(
        icon,
        color: const Color(0xffe1d2fd).withOpacity(opacity)
      ),
    );
  }
}