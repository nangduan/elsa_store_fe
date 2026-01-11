import 'package:flutter/material.dart';

class PaymentMethodBottomSheet extends StatelessWidget {
  const PaymentMethodBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Phương thức thanh toán',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _methodTile(Icons.credit_card, 'Thẻ Master'),
          _methodTile(Icons.credit_card, 'Visa'),
          _methodTile(Icons.account_balance_wallet, 'Ví'),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Xác nhận'),
          ),
        ],
      ),
    );
  }

  Widget _methodTile(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.check_circle, color: Colors.blue),
    );
  }
}
