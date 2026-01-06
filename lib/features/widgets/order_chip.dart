import 'package:flutter/material.dart';

class OrderChip extends StatelessWidget {
  final String label;
  final bool showDot;

  const OrderChip({
    super.key,
    required this.label,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Chip(
            label: Text(label),
            backgroundColor: Colors.blue.shade50,
            labelStyle: const TextStyle(color: Colors.blue),
          ),
          if (showDot)
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
