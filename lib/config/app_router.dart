import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/widgets/main_bottom_nav.dart';
import '../features/auth/presentation/screens/cart_empty_screen.dart';
import '../features/auth/presentation/screens/cart_screen.dart';
import '../features/auth/presentation/screens/category_filter_screen.dart';
import '../features/auth/presentation/screens/flash_sale_screen.dart';
import '../features/auth/presentation/screens/full_profile_screen.dart';
import '../features/auth/presentation/screens/hello_card_screen.dart';
import '../features/auth/presentation/screens/image_recognized_screen.dart';
import '../features/auth/presentation/screens/image_search_result_screen.dart';
import '../features/auth/presentation/screens/image_search_screen.dart';
import '../features/auth/presentation/screens/live_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/new_password_screen.dart';
import '../features/auth/presentation/screens/password_code_screen.dart';
import '../features/auth/presentation/screens/password_recovery_screen.dart';
import '../features/auth/presentation/screens/password_screen.dart';
import '../features/auth/presentation/screens/payment_screen.dart';
import '../features/auth/presentation/screens/product_detail_full_screen.dart';
import '../features/auth/presentation/screens/product_detail_screen.dart';
import '../features/auth/presentation/screens/profile_screen.dart';
import '../features/auth/presentation/screens/ready_card_screen.dart';
import '../features/auth/presentation/screens/recently_viewed_screen.dart';
import '../features/auth/presentation/screens/recognizing_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/review_screen.dart';
import '../features/auth/presentation/screens/search_result_screen.dart';
import '../features/auth/presentation/screens/search_screen.dart';
import '../features/auth/presentation/screens/shop_screen.dart';
import '../features/auth/presentation/screens/start_screen.dart';
import '../features/auth/presentation/screens/story_screen.dart';
import '../features/auth/presentation/screens/variant_bottom_sheet.dart';



final GoRouter appRouter = GoRouter(
  initialLocation: '/start',
  routes: [

    /// ================= START / AUTH =================
    GoRoute(
      path: '/',
      redirect: (_, __) => '/start',
    ),

    GoRoute(
      path: '/start',
      builder: (_, __) => const StartScreen(),
    ),

    // GoRoute(
    //   path: '/login',
    //   builder: (_, __) => const LoginScreen(),
    // ),

    // GoRoute(
    //   path: '/register',
    //   builder: (_, __) => const RegisterScreen(),
    // ),
    //
    // GoRoute(
    //   path: '/password',
    //   builder: (_, __) => const PasswordScreen(),
    // ),
    //
    // GoRoute(
    //   path: '/password-recovery',
    //   builder: (_, __) => const PasswordRecoveryScreen(),
    // ),
    //
    // GoRoute(
    //   path: '/password-code',
    //   builder: (_, __) => const PasswordCodeScreen(),
    // ),
    //
    // GoRoute(
    //   path: '/new-password',
    //   builder: (_, __) => const NewPasswordScreen(),
    // ),

    /// ================= MAIN (BOTTOM NAV) =================
    // GoRoute(
    //   path: '/main',
    //   builder: (_, __) => const MainBottomNav(),
    // ),
    //
    // /// ================= SHOP / PRODUCT =================
    // GoRoute(
    //   path: '/shop',
    //   builder: (_, __) => const ShopScreen(),
    // ),

    GoRoute(
      path: '/product-detail',
      builder: (_, __) => const ProductDetailScreen(),
    ),

    GoRoute(
      path: '/product-detail-full',
      builder: (_, __) => const ProductDetailFullScreen(),
    ),

    GoRoute(
      path: '/flash-sale',
      builder: (_, __) => const FlashSaleScreen(),
    ),

    GoRoute(
      path: '/category-filter',
      builder: (_, __) => const CategoryFilterScreen(),
    ),

    GoRoute(
      path: '/variant',
      builder: (_, __) => const VariantBottomSheet(),
    ),

    /// ================= CART / PAYMENT =================
    GoRoute(
      path: '/cart',
      builder: (_, __) => const CartScreen(),
    ),

    GoRoute(
      path: '/cart-empty',
      builder: (_, __) => const CartEmptyScreen(),
    ),

    GoRoute(
      path: '/payment',
      builder: (_, __) => const PaymentScreen(),
    ),

    /// ================= SEARCH / IMAGE =================
    GoRoute(
      path: '/search',
      builder: (_, __) => const SearchScreen(),
    ),

    GoRoute(
      path: '/search-result',
      builder: (_, __) => const SearchResultScreen(),
    ),

    GoRoute(
      path: '/image-search',
      builder: (_, __) => const ImageSearchScreen(),
    ),

    GoRoute(
      path: '/image-search-result',
      builder: (_, __) => const ImageSearchResultScreen(),
    ),

    GoRoute(
      path: '/image-recognized',
      builder: (_, __) => const ImageRecognizedScreen(),
    ),

    GoRoute(
      path: '/recognizing',
      builder: (_, __) => const RecognizingScreen(),
    ),

    /// ================= PROFILE =================
    GoRoute(
      path: '/profile',
      builder: (_, __) => const ProfileScreen(),
    ),

    GoRoute(
      path: '/profile-full',
      builder: (_, __) => const FullProfileScreen(),
    ),

    /// ================= OTHER =================
    GoRoute(
      path: '/review',
      builder: (_, __) => const ReviewScreen(),
    ),

    GoRoute(
      path: '/recently-viewed',
      builder: (_, __) => const RecentlyViewedScreen(),
    ),

    GoRoute(
      path: '/story',
      builder: (_, __) => const StoryScreen(),
    ),

    GoRoute(
      path: '/live',
      builder: (_, __) => const LiveScreen(),
    ),

    GoRoute(
      path: '/hello-card',
      builder: (_, __) => const HelloCardScreen(),
    ),

    GoRoute(
      path: '/ready-card',
      builder: (_, __) => const ReadyCardScreen(),
    ),
  ],
);
