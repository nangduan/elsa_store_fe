import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_skeleton/features/auth/presentation/controllers/chat_controller.dart';

void main() {
  test('ChatController sendMessage adds user and bot messages and toggles isSending', () async {
    final controller = ChatController();

    expect(controller.messages.length, 0);
    expect(controller.isSending, false);

    controller.textController.text = 'hello test';

    final future = controller.sendMessage();
    // right after calling, isSending should become true
    expect(controller.isSending, true);

    await future; // wait for send to complete

    expect(controller.messages.length, 2);
    expect(controller.messages.first.text, 'hello test');
    expect(controller.messages.first.isUser, true);
    expect(controller.messages[1].isUser, false);
    expect(controller.isSending, false);

    controller.dispose();
  });
}

