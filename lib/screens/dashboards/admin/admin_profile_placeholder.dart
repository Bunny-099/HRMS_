import 'package:flutter/material.dart';

class AdminProfilePlaceholder extends StatelessWidget {
  const AdminProfilePlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Admin Profile\n(Coming Soon)',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
