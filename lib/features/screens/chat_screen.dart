import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_skeleton/features/auth/presentation/controllers/chat_controller.dart';
import 'package:flutter_skeleton/features/widgets/chat_bubble.dart';
import 'package:auto_route/auto_route.dart';

@RoutePage()
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController(),
      child: const _ChatView(),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({Key? key}) : super(key: key);

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (!_scrollController.hasClients) return;
    try {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trợ lý Elsa')),
      body: Consumer<ChatController>(
        builder: (context, controller, _) {
          // Scroll to bottom after frame so new messages are visible
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          final isEmpty = controller.textController.text.trim().isEmpty;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, i) {
                    return ChatBubble(
                      message: controller.messages[i],
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.textController,
                        decoration: const InputDecoration(
                          hintText: 'Nhập câu hỏi...',
                        ),
                        onSubmitted: (_) => controller.sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: controller.isSending
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send),
                      onPressed: (controller.isSending || isEmpty)
                          ? null
                          : controller.sendMessage,
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
