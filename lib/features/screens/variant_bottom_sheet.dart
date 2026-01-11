import 'package:flutter/material.dart';

class VariantBottomSheet extends StatelessWidget {
  const VariantBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '\$17.00',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          const Text('Tùy chọn màu'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              Colors.blue,
              Colors.red,
              Colors.pink,
              Colors.orange,
            ].map((c) => CircleAvatar(radius: 16, backgroundColor: c)).toList(),
          ),

          const SizedBox(height: 16),

          const Text('Kích cỡ'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: ['XS', 'S', 'M', 'L', 'XL']
                .map((e) => ChoiceChip(label: Text(e), selected: e == 'M'))
                .toList(),
          ),

          const SizedBox(height: 16),

          const Text('Số lượng'),
          const SizedBox(height: 8),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {},
              ),
              const Text('1'),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {},
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Thêm vào giỏ'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Mua ngay'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
