import 'package:flutter/material.dart';

void showMaxAttemptDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 40),
          const SizedBox(height: 16),
          const Text(
            'You reached out maximum\namount of attempts.\nPlease, try later.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text('Okay'),
            ),
          ),
        ],
      ),
    ),
  );
}
