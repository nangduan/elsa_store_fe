class ChatService {
  // Simulate sending a message to a backend or AI and receiving a reply.
  // Returns a plain text reply after a short delay.
  static Future<String> send(String message) async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Simple canned response — could be replaced with real API call.
    if (message.toLowerCase().contains('hello') || message.toLowerCase().contains('hi')) {
      return 'Chào bạn! Mình có thể giúp gì cho bạn?';
    }
    return 'Mình đã nhận: "$message"';
  }
}

