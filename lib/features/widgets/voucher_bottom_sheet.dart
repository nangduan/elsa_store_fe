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
          const Text('Active Vouchers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

          const SizedBox(height: 16),

          _VoucherItem(
            title: 'First Purchase',
            subtitle: '5% off your next order',
          ),

          _VoucherItem(
            title: 'Gift from Customer Care',
            subtitle: '15% off your next purchase',
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
          child: const Text('Apply'),
        ),
      ),
    );
  }
}
