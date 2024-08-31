import 'package:flutter/material.dart';

class AuthHeading extends StatelessWidget {
  final String heading;
  const AuthHeading({
    super.key,
    required this.heading,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: TextStyle(
        color: Colors.grey[500],
        fontSize: 20,
        fontWeight: FontWeight.bold,
        letterSpacing: 5,
      ),
    );
  }
}
