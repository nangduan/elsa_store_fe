import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SpecItem extends StatelessWidget {
  final String title;
  final String value;

  const SpecItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value, style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class DeliveryItem extends StatelessWidget {
  final String title;
  final String value;
  final String price;

  const DeliveryItem({
    super.key,
    required this.title,
    required this.value,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Text(value),
          const SizedBox(width: 8),
          Text(price),
        ],
      ),
    );
  }
}
class ReviewItem extends StatelessWidget {
  final String name;
  final String comment;

  const ReviewItem({required this.name, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(child: Icon(Icons.person)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(comment),
            ],
          ),
        ),
      ],
    );
  }
}
