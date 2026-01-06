import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/navigation/app_routes.dart';
import '../../data/models/request/register_request.dart';
import '../../domain/usecases/register_use_case.dart';
import '../cubit/register/register_cubit.dart';

@RoutePage()
class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocProvider(
        create: (_) => RegisterCubit(getIt<RegisterUseCase>()),
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state.status.isSuccess) {
              context.router.replace(const ReadyCardRoute());
            }
            if (state.status.isFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage ?? 'Đăng ký thất bại'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Create\nAccount',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.blue.shade100,
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sử dụng TextFormField thay vì TextField để dùng được _formKey.validate()
                        _buildTextField(usernameController, 'Tên đăng nhập'),
                        const SizedBox(height: 16),
                        _buildTextField(
                          passwordController,
                          'Mật khẩu',
                          isObscure: true,
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(emailController, 'Email của bạn'),
                        const SizedBox(height: 16),
                        _buildTextField(phoneController, 'Số điện thoại'),
                        const SizedBox(height: 16),
                        _buildTextField(fullNameController, 'Họ và tên'),

                        const SizedBox(height: 32), // Thay thế cho Spacer()

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              // Logic đăng ký nên nằm ở nút Done này
                              if (_formKey.currentState!.validate()) {
                                context.read<RegisterCubit>().register(
                                  RegisterRequest(
                                    username: usernameController.text.trim(),
                                    password: passwordController.text.trim(),
                                    email: emailController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    fullName: fullNameController.text.trim(),
                                  ),
                                );
                              }
                            },
                            child: state.status.isLoading
                                ? const CircularProgressIndicator()
                                : const Text('Done'),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: TextButton(
                            onPressed: () => context.router
                                .pop(), // Thường Cancel là quay lại
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    bool isObscure = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) =>
          value == null || value.isEmpty ? 'Vui lòng nhập thông tin' : null,
    );
  }
}
