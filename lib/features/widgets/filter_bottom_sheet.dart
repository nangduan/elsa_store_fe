import 'package:flutter/material.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('Bộ lọc',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Kích cỡ'),
            const SizedBox(height: 8),

            Wrap(
              spacing: 8,
              children: ['XS', 'S', 'M', 'L', 'XL', '2XL']
                  .map((e) => ChoiceChip(
                label: Text(e),
                selected: e == 'M',
              ))
                  .toList(),
            ),

            const SizedBox(height: 24),
            const Text('Màu sắc'),
            const SizedBox(height: 8),

            Wrap(
              spacing: 12,
              children: [
                Colors.blue,
                Colors.black,
                Colors.red,
                Colors.green,
                Colors.orange,
                Colors.purple,
              ]
                  .map(
                    (c) => CircleAvatar(
                  backgroundColor: c,
                  radius: 14,
                ),
              )
                  .toList(),
            ),

            const SizedBox(height: 24),
            const Text('Giá'),

            RangeSlider(
              values: const RangeValues(10, 150),
              min: 0,
              max: 300,
              onChanged: (_) {},
            ),

            const SizedBox(height: 24),

            Row(
              children: [
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('Xóa'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}