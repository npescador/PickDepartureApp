import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/presentation/view/authentication/login_page.dart';
import 'package:pick_departure_app/presentation/view/home/home_page.dart';
import 'package:pick_departure_app/presentation/view/orders/new_order/new_order_page.dart';
import 'package:pick_departure_app/presentation/view/orders/order_detail/order_detail_page.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/order_list_page.dart';
import 'package:pick_departure_app/presentation/view/orders/order_preparation/order_preparation_page.dart';
import 'package:pick_departure_app/presentation/view/products/product_list_page.dart';
import 'package:pick_departure_app/presentation/view/splash/splash_page.dart';
import 'package:pick_departure_app/presentation/view/users/users_list_page.dart';

class NavigationRoutes {
  static const INITIAL_ROUTE = "/";

  static const LOGIN_ROUTE = "/login";

  static const HOME_PATH = "home";
  static const HOME_ROUTE = "$LOGIN_ROUTE/$HOME_PATH";

  static const ORDERS_PATH = "orders";
  static const ORDERS_ROUTE = "$LOGIN_ROUTE/$ORDERS_PATH";

  static const PRODUCTS_PATH = "productos";
  static const PRODUCTS_ROUTE = "$LOGIN_ROUTE/$PRODUCTS_PATH";

  static const USERS_PATH = "users";
  static const USERS_ROUTE = "$LOGIN_ROUTE/$USERS_PATH";

  static const _ORDER_DETAIL_PATH = "orderDetail";
  static const ORDER_DETAIL_ROUTE = "$ORDERS_ROUTE/$_ORDER_DETAIL_PATH";

  static const _NEW_ORDER_PATH = "newOrder";
  static const NEW_ORDER_ROUTE = "$ORDERS_ROUTE/$_NEW_ORDER_PATH";

  static const _ORDER_PREPARATION_PATH = "orderPreparation";
  static const ORDER_PREAPARATION_ROUTE =
      "$ORDERS_ROUTE/$_ORDER_DETAIL_PATH/$_ORDER_PREPARATION_PATH";
}

final GoRouter router = GoRouter(
  initialLocation: NavigationRoutes.INITIAL_ROUTE,
  routes: [
    GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: NavigationRoutes.LOGIN_ROUTE,
      builder: (context, state) => const LoginPage(),
    ),
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomePage(
              navigationShell: navigationShell,
            ),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.PRODUCTS_ROUTE,
              builder: (context, state) => const ProductsListPage(),
            )
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.ORDERS_ROUTE,
              builder: (context, state) => const OrderListPage(),
              routes: [
                GoRoute(
                  path: NavigationRoutes._ORDER_DETAIL_PATH,
                  builder: (context, state) => const OrderDetailPage(),
                  routes: [
                    GoRoute(
                      path: NavigationRoutes._ORDER_PREPARATION_PATH,
                      builder: (context, state) => const OrderPreparationPage(),
                    )
                  ],
                ),
                GoRoute(
                  path: NavigationRoutes._NEW_ORDER_PATH,
                  builder: (context, state) => NewOrderPage(
                    saveOrder: state.extra as Function(),
                  ),
                )
              ],
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: NavigationRoutes.USERS_ROUTE,
              builder: (context, state) => const UsersListPage(),
            )
          ]),
        ]),
  ],
);
