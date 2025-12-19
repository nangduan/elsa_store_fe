import 'package:flutter/material.dart';

import '../widgets/order_chip.dart';
import '../widgets/story_card.dart';

class FullProfileScreen extends StatelessWidget {
  const FullProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Header
            Row(
              children: [
                const CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/women/44.jpg',
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'My Activity',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {},
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              'Hello, Romina!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Announcement
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Announcement',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.arrow_forward, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            const Text('Recently viewed',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/women/${20 + i}.jpg',
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text('My Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            Row(
              children: const [
                OrderChip(label: 'To Pay'),
                OrderChip(label: 'To Receive', showDot: true),
                OrderChip(label: 'To Review'),
              ],
            ),

            const SizedBox(height: 24),

            const Text('Stories',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 12),

            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, i) => StoryCard(
                  imageUrl:
                  'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
                  isLive: i == 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
