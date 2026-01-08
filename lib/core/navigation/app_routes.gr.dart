// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_routes.dart';

/// generated route for
/// [AdminScreen]
class AdminRoute extends PageRouteInfo<void> {
  const AdminRoute({List<PageRouteInfo>? children})
    : super(AdminRoute.name, initialChildren: children);

  static const String name = 'AdminRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AdminScreen();
    },
  );
}

/// generated route for
/// [CartEmptyScreen]
class CartEmptyRoute extends PageRouteInfo<CartEmptyRouteArgs> {
  CartEmptyRoute({
    Key? key,
    bool fromWishlist = true,
    List<PageRouteInfo>? children,
  }) : super(
         CartEmptyRoute.name,
         args: CartEmptyRouteArgs(key: key, fromWishlist: fromWishlist),
         initialChildren: children,
       );

  static const String name = 'CartEmptyRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CartEmptyRouteArgs>(
        orElse: () => const CartEmptyRouteArgs(),
      );
      return CartEmptyScreen(key: args.key, fromWishlist: args.fromWishlist);
    },
  );
}

class CartEmptyRouteArgs {
  const CartEmptyRouteArgs({this.key, this.fromWishlist = true});

  final Key? key;

  final bool fromWishlist;

  @override
  String toString() {
    return 'CartEmptyRouteArgs{key: $key, fromWishlist: $fromWishlist}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CartEmptyRouteArgs) return false;
    return key == other.key && fromWishlist == other.fromWishlist;
  }

  @override
  int get hashCode => key.hashCode ^ fromWishlist.hashCode;
}

/// generated route for
/// [CartScreen]
class CartRoute extends PageRouteInfo<void> {
  const CartRoute({List<PageRouteInfo>? children})
    : super(CartRoute.name, initialChildren: children);

  static const String name = 'CartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CartScreen();
    },
  );
}

/// generated route for
/// [CategoryFilterScreen]
class CategoryFilterRoute extends PageRouteInfo<void> {
  const CategoryFilterRoute({List<PageRouteInfo>? children})
    : super(CategoryFilterRoute.name, initialChildren: children);

  static const String name = 'CategoryFilterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoryFilterScreen();
    },
  );
}

/// generated route for
/// [CategoryManagementScreen]
class CategoryManagementRoute extends PageRouteInfo<void> {
  const CategoryManagementRoute({List<PageRouteInfo>? children})
    : super(CategoryManagementRoute.name, initialChildren: children);

  static const String name = 'CategoryManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CategoryManagementScreen();
    },
  );
}

/// generated route for
/// [ChatScreen]
class ChatRoute extends PageRouteInfo<void> {
  const ChatRoute({List<PageRouteInfo>? children})
    : super(ChatRoute.name, initialChildren: children);

  static const String name = 'ChatRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ChatScreen();
    },
  );
}

/// generated route for
/// [FlashSaleScreen]
class FlashSaleRoute extends PageRouteInfo<void> {
  const FlashSaleRoute({List<PageRouteInfo>? children})
    : super(FlashSaleRoute.name, initialChildren: children);

  static const String name = 'FlashSaleRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FlashSaleScreen();
    },
  );
}

/// generated route for
/// [FullProfileScreen]
class FullProfileRoute extends PageRouteInfo<void> {
  const FullProfileRoute({List<PageRouteInfo>? children})
    : super(FullProfileRoute.name, initialChildren: children);

  static const String name = 'FullProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const FullProfileScreen();
    },
  );
}

/// generated route for
/// [HelloCardScreen]
class HelloCardRoute extends PageRouteInfo<void> {
  const HelloCardRoute({List<PageRouteInfo>? children})
    : super(HelloCardRoute.name, initialChildren: children);

  static const String name = 'HelloCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HelloCardScreen();
    },
  );
}

/// generated route for
/// [HomeScreen]
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute({List<PageRouteInfo>? children})
    : super(HomeRoute.name, initialChildren: children);

  static const String name = 'HomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeScreen();
    },
  );
}

/// generated route for
/// [ImageRecognizedScreen]
class ImageRecognizedRoute extends PageRouteInfo<void> {
  const ImageRecognizedRoute({List<PageRouteInfo>? children})
    : super(ImageRecognizedRoute.name, initialChildren: children);

  static const String name = 'ImageRecognizedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImageRecognizedScreen();
    },
  );
}

/// generated route for
/// [ImageSearchResultScreen]
class ImageSearchResultRoute extends PageRouteInfo<void> {
  const ImageSearchResultRoute({List<PageRouteInfo>? children})
    : super(ImageSearchResultRoute.name, initialChildren: children);

  static const String name = 'ImageSearchResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImageSearchResultScreen();
    },
  );
}

/// generated route for
/// [ImageSearchScreen]
class ImageSearchRoute extends PageRouteInfo<void> {
  const ImageSearchRoute({List<PageRouteInfo>? children})
    : super(ImageSearchRoute.name, initialChildren: children);

  static const String name = 'ImageSearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ImageSearchScreen();
    },
  );
}

/// generated route for
/// [LiveScreen]
class LiveRoute extends PageRouteInfo<void> {
  const LiveRoute({List<PageRouteInfo>? children})
    : super(LiveRoute.name, initialChildren: children);

  static const String name = 'LiveRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LiveScreen();
    },
  );
}

/// generated route for
/// [LoginScreen]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
    : super(LoginRoute.name, initialChildren: children);

  static const String name = 'LoginRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const LoginScreen();
    },
  );
}

/// generated route for
/// [MainBottomNavScreen]
class MainBottomNavRoute extends PageRouteInfo<void> {
  const MainBottomNavRoute({List<PageRouteInfo>? children})
    : super(MainBottomNavRoute.name, initialChildren: children);

  static const String name = 'MainBottomNavRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainBottomNavScreen();
    },
  );
}

/// generated route for
/// [NewPasswordScreen]
class NewPasswordRoute extends PageRouteInfo<void> {
  const NewPasswordRoute({List<PageRouteInfo>? children})
    : super(NewPasswordRoute.name, initialChildren: children);

  static const String name = 'NewPasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const NewPasswordScreen();
    },
  );
}

/// generated route for
/// [PasswordCodeScreen]
class PasswordCodeRoute extends PageRouteInfo<void> {
  const PasswordCodeRoute({List<PageRouteInfo>? children})
    : super(PasswordCodeRoute.name, initialChildren: children);

  static const String name = 'PasswordCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PasswordCodeScreen();
    },
  );
}

/// generated route for
/// [PasswordRecoveryScreen]
class PasswordRecoveryRoute extends PageRouteInfo<void> {
  const PasswordRecoveryRoute({List<PageRouteInfo>? children})
    : super(PasswordRecoveryRoute.name, initialChildren: children);

  static const String name = 'PasswordRecoveryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PasswordRecoveryScreen();
    },
  );
}

/// generated route for
/// [PasswordScreen]
class PasswordRoute extends PageRouteInfo<void> {
  const PasswordRoute({List<PageRouteInfo>? children})
    : super(PasswordRoute.name, initialChildren: children);

  static const String name = 'PasswordRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PasswordScreen();
    },
  );
}

/// generated route for
/// [PaymentScreen]
class PaymentRoute extends PageRouteInfo<void> {
  const PaymentRoute({List<PageRouteInfo>? children})
    : super(PaymentRoute.name, initialChildren: children);

  static const String name = 'PaymentRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaymentScreen();
    },
  );
}

/// generated route for
/// [ProductDetailFullScreen]
class ProductDetailFullRoute extends PageRouteInfo<ProductDetailFullRouteArgs> {
  ProductDetailFullRoute({
    Key? key,
    required ProductResponse product,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailFullRoute.name,
         args: ProductDetailFullRouteArgs(key: key, product: product),
         initialChildren: children,
       );

  static const String name = 'ProductDetailFullRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailFullRouteArgs>();
      return ProductDetailFullScreen(key: args.key, product: args.product);
    },
  );
}

class ProductDetailFullRouteArgs {
  const ProductDetailFullRouteArgs({this.key, required this.product});

  final Key? key;

  final ProductResponse product;

  @override
  String toString() {
    return 'ProductDetailFullRouteArgs{key: $key, product: $product}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailFullRouteArgs) return false;
    return key == other.key && product == other.product;
  }

  @override
  int get hashCode => key.hashCode ^ product.hashCode;
}

/// generated route for
/// [ProductDetailScreen]
class ProductDetailRoute extends PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    Key? key,
    bool isSale = false,
    List<PageRouteInfo>? children,
  }) : super(
         ProductDetailRoute.name,
         args: ProductDetailRouteArgs(key: key, isSale: isSale),
         initialChildren: children,
       );

  static const String name = 'ProductDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>(
        orElse: () => const ProductDetailRouteArgs(),
      );
      return ProductDetailScreen(key: args.key, isSale: args.isSale);
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({this.key, this.isSale = false});

  final Key? key;

  final bool isSale;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, isSale: $isSale}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductDetailRouteArgs) return false;
    return key == other.key && isSale == other.isSale;
  }

  @override
  int get hashCode => key.hashCode ^ isSale.hashCode;
}

/// generated route for
/// [ProfileScreen]
class ProfileRoute extends PageRouteInfo<void> {
  const ProfileRoute({List<PageRouteInfo>? children})
    : super(ProfileRoute.name, initialChildren: children);

  static const String name = 'ProfileRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ProfileScreen();
    },
  );
}

/// generated route for
/// [ReadyCardScreen]
class ReadyCardRoute extends PageRouteInfo<void> {
  const ReadyCardRoute({List<PageRouteInfo>? children})
    : super(ReadyCardRoute.name, initialChildren: children);

  static const String name = 'ReadyCardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReadyCardScreen();
    },
  );
}

/// generated route for
/// [RecentlyViewedScreen]
class RecentlyViewedRoute extends PageRouteInfo<void> {
  const RecentlyViewedRoute({List<PageRouteInfo>? children})
    : super(RecentlyViewedRoute.name, initialChildren: children);

  static const String name = 'RecentlyViewedRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecentlyViewedScreen();
    },
  );
}

/// generated route for
/// [RecognizingScreen]
class RecognizingRoute extends PageRouteInfo<void> {
  const RecognizingRoute({List<PageRouteInfo>? children})
    : super(RecognizingRoute.name, initialChildren: children);

  static const String name = 'RecognizingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RecognizingScreen();
    },
  );
}

/// generated route for
/// [RegisterScreen]
class RegisterRoute extends PageRouteInfo<void> {
  const RegisterRoute({List<PageRouteInfo>? children})
    : super(RegisterRoute.name, initialChildren: children);

  static const String name = 'RegisterRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const RegisterScreen();
    },
  );
}

/// generated route for
/// [ReviewScreen]
class ReviewRoute extends PageRouteInfo<void> {
  const ReviewRoute({List<PageRouteInfo>? children})
    : super(ReviewRoute.name, initialChildren: children);

  static const String name = 'ReviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ReviewScreen();
    },
  );
}

/// generated route for
/// [SearchResultScreen]
class SearchResultRoute extends PageRouteInfo<void> {
  const SearchResultRoute({List<PageRouteInfo>? children})
    : super(SearchResultRoute.name, initialChildren: children);

  static const String name = 'SearchResultRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchResultScreen();
    },
  );
}

/// generated route for
/// [SearchScreen]
class SearchRoute extends PageRouteInfo<void> {
  const SearchRoute({List<PageRouteInfo>? children})
    : super(SearchRoute.name, initialChildren: children);

  static const String name = 'SearchRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SearchScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [ShopScreen]
class ShopRoute extends PageRouteInfo<void> {
  const ShopRoute({List<PageRouteInfo>? children})
    : super(ShopRoute.name, initialChildren: children);

  static const String name = 'ShopRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ShopScreen();
    },
  );
}

/// generated route for
/// [StartScreen]
class StartRoute extends PageRouteInfo<void> {
  const StartRoute({List<PageRouteInfo>? children})
    : super(StartRoute.name, initialChildren: children);

  static const String name = 'StartRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StartScreen();
    },
  );
}

/// generated route for
/// [StoryScreen]
class StoryRoute extends PageRouteInfo<void> {
  const StoryRoute({List<PageRouteInfo>? children})
    : super(StoryRoute.name, initialChildren: children);

  static const String name = 'StoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const StoryScreen();
    },
  );
}

/// generated route for
/// [SupplierManagementScreen]
class SupplierManagementRoute extends PageRouteInfo<void> {
  const SupplierManagementRoute({List<PageRouteInfo>? children})
    : super(SupplierManagementRoute.name, initialChildren: children);

  static const String name = 'SupplierManagementRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SupplierManagementScreen();
    },
  );
}

/// generated route for
/// [WishlistScreen]
class WishlistRoute extends PageRouteInfo<WishlistRouteArgs> {
  WishlistRoute({Key? key, bool isEmpty = false, List<PageRouteInfo>? children})
    : super(
        WishlistRoute.name,
        args: WishlistRouteArgs(key: key, isEmpty: isEmpty),
        initialChildren: children,
      );

  static const String name = 'WishlistRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<WishlistRouteArgs>(
        orElse: () => const WishlistRouteArgs(),
      );
      return WishlistScreen(key: args.key, isEmpty: args.isEmpty);
    },
  );
}

class WishlistRouteArgs {
  const WishlistRouteArgs({this.key, this.isEmpty = false});

  final Key? key;

  final bool isEmpty;

  @override
  String toString() {
    return 'WishlistRouteArgs{key: $key, isEmpty: $isEmpty}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WishlistRouteArgs) return false;
    return key == other.key && isEmpty == other.isEmpty;
  }

  @override
  int get hashCode => key.hashCode ^ isEmpty.hashCode;
}
