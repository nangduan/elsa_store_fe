import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class CartEmptyScreen extends StatelessWidget {
  final bool fromWishlist;

  const CartEmptyScreen({super.key, this.fromWishlist = true});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Giỏ hàng')),
      body: Column(
        children: [
          const SizedBox(height: 48),

          // Empty icon
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFF2F2F2),
            child: Icon(Icons.shopping_bag_outlined, size: 36),
          ),

          const SizedBox(height: 12),
          const Text('Giỏ hàng của bạn trống'),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  fromWishlist ? 'Từ danh sách yêu thích' : 'Phổ biến nhất',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Xem tất cả')),
              ],
            ),
          ),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: 2,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, __) => _SuggestItem(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: const [
                Text('Tổng'),
                Spacer(),
                Text('\$0.00',
                    style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Thanh toán'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
            height: 80,
            width: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nội dung mẫu'),
              Text('\$17.00'),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {},
          child: const Text('Thẻm'),
        ),
      ],
    );
  }
}
