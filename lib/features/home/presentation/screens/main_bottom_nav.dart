import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injector.dart';
import '../../../cart/presentation/cubit/cart_cubit.dart';
import '../../../cart/presentation/screen/cart_screen.dart';
import '../../../orders/presentation/cubit/order_cubit.dart';
import '../../../orders/presentation/screen/orders_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'search_screen.dart';

@RoutePage()
class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _currentIndex = 0;
  late final CartCubit _cartCubit;
  late final OrderCubit _orderCubit;

  @override
  void initState() {
    super.initState();
    _cartCubit = getIt<CartCubit>();
    _orderCubit = getIt<OrderCubit>();
  }

  @override
  void dispose() {
    _cartCubit.close();
    _orderCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _cartCubit),
        BlocProvider.value(value: _orderCubit),
      ],
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: const [
            HomeScreen(),
            OrdersScreen(),
            SearchScreen(),
            CartScreen(),
            ProfileScreen(),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey.shade100, width: 1),
            ),
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.black, // Dong bo voi mau nut Login
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 12),
            elevation: 0,
            onTap: (index) {
              setState(() => _currentIndex = index);
              if (index == 3) {
                _cartCubit.load();
              } else if (index == 1) {
                _orderCubit.load();
              }
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Trang chủ',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long_outlined),
                activeIcon: Icon(Icons.receipt_long),
                label: 'Đơn hàng',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.search_rounded),
                label: 'Tìm kiếm',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag_outlined),
                activeIcon: Icon(Icons.shopping_bag),
                label: 'Giỏ hàng',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Tài khoản',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
