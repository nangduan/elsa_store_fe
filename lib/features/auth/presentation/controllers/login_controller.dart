import 'package:flutter/material.dart';

class LoginController extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String password = '';
  bool hasError = false;

  void addDigit() {
    if (password.length < 6) {
      password += '*';
      notifyListeners();
    }

    if (password.length == 6) {
      validatePassword();
    }
  }

  void validatePassword() {
    hasError = true;
    notifyListeners();
  }

  void reset() {
    password = '';
    hasError = false;
    notifyListeners();
  }

  Future<bool> login() async {
    await Future.delayed(const Duration(seconds: 1));
    return emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
