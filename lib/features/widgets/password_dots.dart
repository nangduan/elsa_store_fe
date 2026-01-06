import 'package:flutter/material.dart';

class PasswordDots extends StatelessWidget {
  final int length;
  final int filled;
  final bool error;

  const PasswordDots({
    super.key,
    required this.length,
    required this.filled,
    this.error = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: index < filled
                ? (error ? Colors.red : Colors.blue)
                : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}
