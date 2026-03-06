import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../features/admin/presentation/screens/category_management_screen.dart';
import '../../features/admin/presentation/screens/product_management_screen.dart';
import '../../features/admin/presentation/screens/product_variant_management_screen.dart';
import '../../features/admin/presentation/screens/promotion_management_screen.dart';
import '../../features/admin/presentation/screens/supplier_management_screen.dart';
import '../../features/cart/data/models/response/cart_item_response.dart';
import '../../features/home/data/models/response/product_response.dart';
import '../../features/cart/presentation/screen/cart_screen.dart';
import '../../features/orders/presentation/screen/orders_screen.dart';
import '../../features/screens/flash_sale_screen.dart';
import '../../features/screens/image_recognized_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/screens/new_password_screen.dart';
import '../../features/screens/password_recovery_screen.dart';
import '../../features/screens/payment_screen.dart';
import '../../features/screens/product_detail_full_screen.dart';
import '../../features/home/presentation/screens/profile_screen.dart';
import '../../features/screens/recognizing_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/home/presentation/screens/shop_screen.dart';
import '../../features/start/presentation/screen/start_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/screens/main_bottom_nav.dart';
import '../../features/admin/presentation/screens/admin_screen.dart';

part 'app_routes.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Screen,Route')
class AppRoutes extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      page: StartRoute.page,
      path: '/${StartRoute.name}',
      initial: true,
    ),
    AutoRoute(page: OrdersRoute.page, path: '/${OrdersRoute.name}'),
    AutoRoute(
      page: CategoryManagementRoute.page,
      path: '/${CategoryManagementRoute.name}',
    ),
    AutoRoute(
      page: SupplierManagementRoute.page,
      path: '/${SupplierManagementRoute.name}',
    ),
    AutoRoute(
      page: ProductManagementRoute.page,
      path: '/${ProductManagementRoute.name}',
    ),
    AutoRoute(
      page: ProductVariantManagementRoute.page,
      path: '/${ProductVariantManagementRoute.name}',
    ),
    AutoRoute(
      page: PromotionManagementRoute.page,
      path: '/${PromotionManagementRoute.name}',
    ),
    AutoRoute(page: RegisterRoute.page, path: '/${RegisterRoute.name}'),
    AutoRoute(page: LoginRoute.page, path: '/${LoginRoute.name}'),
    AutoRoute(
      page: PasswordRecoveryRoute.page,
      path: '/${PasswordRecoveryRoute.name}-recovery',
    ),
    AutoRoute(
      page: NewPasswordRoute.page,
      path: '/${NewPasswordRoute.name}-password',
    ),
    AutoRoute(
      page: MainBottomNavRoute.page,
      path: '/${MainBottomNavRoute.name}',
    ),
    AutoRoute(
      page: ProductDetailFullRoute.page,
      path: '/${ProductDetailFullRoute.name}-detail-full',
    ),
    AutoRoute(page: FlashSaleRoute.page, path: '/${FlashSaleRoute.name}-sale'),
    AutoRoute(page: PaymentRoute.page, path: '/${PaymentRoute.name}'),
    AutoRoute(
      page: ImageRecognizedRoute.page,
      path: '/${ImageRecognizedRoute.name}-recognized',
    ),
    AutoRoute(page: RecognizingRoute.page, path: '/${RecognizingRoute.name}'),
    AutoRoute(page: HomeRoute.page, path: '/${HomeRoute.name}'),
    AutoRoute(page: AdminRoute.page, path: '/${AdminRoute.name}'),
  ];
}
