import 'package:flutter/material.dart';


class StoryCard extends StatelessWidget {
  final String imageUrl;
  final bool isLive;

  const StoryCard({
    super.key,
    required this.imageUrl,
    this.isLive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            imageUrl,
            width: 120,
            height: 180,
            fit: BoxFit.cover,
          ),
        ),
        if (isLive)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Live',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        const Positioned.fill(
          child: Center(
            child: Icon(
              Icons.play_circle_fill,
              color: Colors.white,
              size: 40,
            ),
          ),
        ),
      ],
    );
  }
}
