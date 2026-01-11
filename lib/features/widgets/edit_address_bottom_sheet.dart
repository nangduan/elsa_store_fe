import 'package:flutter/material.dart';

class EditAddressBottomSheet extends StatelessWidget {
  const EditAddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Địa chỉ giao hàng',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const TextField(decoration: InputDecoration(labelText: 'Quốc gia')),
            const TextField(decoration: InputDecoration(labelText: 'Địa chỉ')),
            const TextField(decoration: InputDecoration(labelText: 'Thành phố')),
            const TextField(decoration: InputDecoration(labelText: 'Mã bưu chính')),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Lưu thay ??i'),
            ),
          ],
        ),
      ),
    );
  }
}
