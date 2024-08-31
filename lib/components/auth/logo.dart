import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String imageUrl;
  final double height;

  const Logo({
    super.key,
    this.imageUrl = 'assets/logo.png',
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      imageUrl,
      height: height,
    );
  }
}
