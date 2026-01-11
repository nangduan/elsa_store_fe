import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';

@RoutePage()
class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _InfoTile(
            title: 'Địa chỉ giao hàng',
            subtitle: '26 Dong Da, Ward 2, District 2\nHo Chi Minh City',
          ),

          const _InfoTile(
            title: 'Contact Information',
            subtitle: '+84900000000\nexample@gmail.com',
          ),

          Row(
            children: [
              const Text(
                'Items',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '5% Discount',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),


          const _ItemRow(),
          const _ItemRow(),

          const SizedBox(height: 16),
          const Text('Tùy chọn giao hàng',
              style: TextStyle(fontWeight: FontWeight.bold)),

          const RadioListTile(
            value: true,
            groupValue: true,
            onChanged: null,
            title: Text('Standard (5–7 days)'),
            subtitle: Text('MIỄN PHÍ'),
          ),

          const RadioListTile(
            value: false,
            groupValue: true,
            onChanged: null,
            title: Text('Express (1–2 days)'),
            subtitle: Text('\$12.00'),
          ),

          const SizedBox(height: 16),
          const Text('Phương thức thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold)),

          const ListTile(
            leading: Icon(Icons.credit_card),
            title: Text('Thẻ'),
          ),

          const SizedBox(height: 24),
          Row(
            children: const [
              Text('Tổng',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Spacer(),
              Text('\$34.00',
                  style:
                  TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),

          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Thanh toán'),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _InfoTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.edit),
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(),
      title: const Text('Nội dung mẫu'),
      trailing: const Text('\$17.00'),
    );
  }
}
