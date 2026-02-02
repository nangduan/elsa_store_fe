import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'dart:ui'; // Để dùng BackdropFilter nếu cần

@RoutePage()
class HelloCardScreen extends StatelessWidget {
  const HelloCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = const Color(0xFF6C63FF);
    final Color secondaryColor = const Color(0xFF64B5F6);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE0EAFC), // Màu xám xanh rất nhạt
              const Color(0xFFCFDEF3), // Màu xanh nhạt
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // --- PHẦN THẺ CHÍNH (CARD) ---
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    // Bo góc thật lớn để tạo sự mềm mại
                    borderRadius: BorderRadius.circular(40),
                    // Bóng đổ thật mờ và lan rộng (Soft Shadow)
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.15),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                        spreadRadius: -5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // 1. Hình ảnh
                      Expanded(
                        flex: 6, // Chiếm 6 phần
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(40),
                              bottom: Radius.circular(0),
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.05), // Bóng nhẹ cực mờ
                                ],
                                stops: const [0.7, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 2. Nội dung text
                      Expanded(
                        flex: 4, // Chiếm 4 phần
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Xin chào!',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.grey.shade800,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Khám phá bộ sưu tập thời trang\nmới nhất dành riêng cho bạn\ntại Elsa Shop.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(32, 10, 32, 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Indicators (Dấu chấm)
                    Row(
                      children: List.generate(4, (index) {
                        // Logic để tạo hiệu ứng "active"
                        final isActive = index == 1; // Giả sử đang ở trang 2 (index 1)
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.only(right: 6),
                          height: 8,
                          width: isActive ? 24 : 8, // Nếu active thì dài ra
                          decoration: BoxDecoration(
                            color: isActive ? primaryColor : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),

                    // Nút Next cách điệu
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: primaryColor.withOpacity(0.4),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 28),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}