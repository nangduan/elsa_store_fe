import 'package:flutter/material.dart';
import 'package:flutter_skeleton/core/service/chat_message.dart';
import 'package:flutter_skeleton/core/service/chat_service.dart';

class ChatController extends ChangeNotifier {
  final TextEditingController textController = TextEditingController();
  final List<ChatMessage> messages = [];
  bool isSending = false;

  Future<void> sendMessage() async {
    final text = textController.text.trim();
    if (text.isEmpty || isSending) return;

    messages.add(ChatMessage(text: text, isUser: true));
    textController.clear();
    notifyListeners();

    isSending = true;
    notifyListeners();

    try {
      final reply = await ChatService.send(text);
      messages.add(ChatMessage(text: reply, isUser: false));
    } catch (e) {
      messages.add(ChatMessage(text: 'Lỗi khi gửi tin nhắn: ${e.toString()}', isUser: false));
    } finally {
      isSending = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
