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
              'Shipping Address',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            const TextField(decoration: InputDecoration(labelText: 'Country')),
            const TextField(decoration: InputDecoration(labelText: 'Address')),
            const TextField(decoration: InputDecoration(labelText: 'City')),
            const TextField(decoration: InputDecoration(labelText: 'Postcode')),

            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
