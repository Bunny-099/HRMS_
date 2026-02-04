import 'package:flutter/material.dart';

const Color _bg = Color(0xFFFFFACD);

class SoftCard extends StatelessWidget {
  final Widget child;
  const SoftCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: const Color(0xFFFFFACD),
            offset: Offset(-6, -6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: const Color(0xFFFF69B4),
            offset: Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: child,
    );
  }
}

class SoftButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap; // ✅ nullable

  const SoftButton({
    super.key,
    required this.text,
    this.onTap,
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SoftCard(
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
      ),
    );
  }
}