import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../features/screens/cart_empty_screen.dart';
import '../../features/screens/cart_screen.dart';
import '../../features/screens/category_filter_screen.dart';
import '../../features/screens/chat_screen.dart';
import '../../features/screens/flash_sale_screen.dart';
import '../../features/screens/full_profile_screen.dart';
import '../../features/screens/hello_card_screen.dart';
import '../../features/screens/image_recognized_screen.dart';
import '../../features/screens/image_search_result_screen.dart';
import '../../features/screens/image_search_screen.dart';
import '../../features/screens/live_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/screens/new_password_screen.dart';
import '../../features/screens/password_code_screen.dart';
import '../../features/screens/password_recovery_screen.dart';
import '../../features/screens/password_screen.dart';
import '../../features/screens/payment_screen.dart';
import '../../features/screens/product_detail_full_screen.dart';
import '../../features/screens/product_detail_screen.dart';
import '../../features/screens/profile_screen.dart';
import '../../features/screens/ready_card_screen.dart';
import '../../features/screens/recently_viewed_screen.dart';
import '../../features/screens/recognizing_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/screens/review_screen.dart';
import '../../features/screens/search_result_screen.dart';
import '../../features/screens/search_screen.dart';
import '../../features/screens/shop_screen.dart';
import '../../features/start/presentation/screen/start_screen.dart';
import '../../features/screens/story_screen.dart';
import '../../features/screens/wishlist_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/widgets/main_bottom_nav.dart';

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
    AutoRoute(page: RegisterRoute.page, path: '/${RegisterRoute.name}'),
    AutoRoute(page: LoginRoute.page, path: '/${LoginRoute.name}'),
    AutoRoute(page: PasswordRoute.page, path: '/${PasswordRoute.name}'),
    AutoRoute(
      page: PasswordRecoveryRoute.page,
      path: '/${PasswordRecoveryRoute.name}-recovery',
    ),
    AutoRoute(
      page: PasswordCodeRoute.page,
      path: '/${PasswordCodeRoute.name}-code',
    ),
    AutoRoute(
      page: NewPasswordRoute.page,
      path: '/${NewPasswordRoute.name}-password',
    ),
    AutoRoute(page: ReadyCardRoute.page, path: '/${ReadyCardRoute.name}'),
    AutoRoute(
      page: MainBottomNavRoute.page,
      path: '/${MainBottomNavRoute.name}',
    ),
    AutoRoute(page: ShopRoute.page, path: '/${ShopRoute.name}'),
    AutoRoute(
      page: ProductDetailRoute.page,
      path: '/${ProductDetailRoute.name}-detail',
    ),
    AutoRoute(
      page: ProductDetailFullRoute.page,
      path: '/${ProductDetailFullRoute.name}-detail-full',
    ),
    AutoRoute(page: FlashSaleRoute.page, path: '/${FlashSaleRoute.name}-sale'),
    AutoRoute(
      page: CategoryFilterRoute.page,
      path: '/${CategoryFilterRoute.name}-filter',
    ),
    AutoRoute(page: CartRoute.page, path: '/${CartRoute.name}'),
    AutoRoute(page: CartEmptyRoute.page, path: '/${CartEmptyRoute.name}-empty'),
    AutoRoute(page: PaymentRoute.page, path: '/${PaymentRoute.name}'),
    AutoRoute(page: SearchRoute.page, path: '/${SearchRoute.name}'),
    AutoRoute(page: SettingsRoute.page, path: '/${SettingsRoute.name}'),
    AutoRoute(
      page: SearchResultRoute.page,
      path: '/${SearchResultRoute.name}-result',
    ),
    AutoRoute(
      page: ImageSearchRoute.page,
      path: '/${ImageSearchRoute.name}-search',
    ),
    AutoRoute(
      page: ImageSearchResultRoute.page,
      path: '/${ImageSearchResultRoute.name}-search-result',
    ),
    AutoRoute(
      page: ImageRecognizedRoute.page,
      path: '/${ImageRecognizedRoute.name}-recognized',
    ),
    AutoRoute(page: RecognizingRoute.page, path: '/${RecognizingRoute.name}'),
    AutoRoute(page: ProfileRoute.page, path: '/${ProfileRoute.name}'),
    AutoRoute(
      page: FullProfileRoute.page,
      path: '/${FullProfileRoute.name}-full',
    ),
    AutoRoute(page: ReviewRoute.page, path: '/${ReviewRoute.name}'),
    AutoRoute(
      page: RecentlyViewedRoute.page,
      path: '/${RecentlyViewedRoute.name}-viewed',
    ),
    AutoRoute(page: StoryRoute.page, path: '/${StoryRoute.name}'),
    AutoRoute(page: LiveRoute.page, path: '/${LiveRoute.name}'),
    AutoRoute(page: HelloCardRoute.page, path: '/${HelloCardRoute.name}-card'),
    AutoRoute(page: ChatRoute.page, path: '/${ChatRoute.name}'),
    AutoRoute(page: HomeRoute.page, path: '/${HomeRoute.name}'),
  ];
}
