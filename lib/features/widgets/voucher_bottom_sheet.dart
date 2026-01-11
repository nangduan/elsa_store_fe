import 'package:flutter/material.dart';

class VoucherBottomSheet extends StatelessWidget {
  const VoucherBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Voucher đang hoạt động',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          _VoucherItem(
            title: 'Lần mua đầu',
            subtitle: 'Giảm 5% cho đơn tiếp theo',
          ),

          _VoucherItem(
            title: 'Quà từ CSKH',
            subtitle: 'Giảm 15% cho lần mua tiếp theo',
          ),
        ],
      ),
    );
  }
}

class _VoucherItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _VoucherItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Áp dụng'),
        ),
      ),
    );
  }
}
