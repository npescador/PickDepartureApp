import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/presentation/view/home/home_page.dart';
import 'package:pick_departure_app/presentation/view/orders/new_order/new_order_page.dart';
import 'package:pick_departure_app/presentation/view/orders/order_detail/order_detail_page.dart';
import 'package:pick_departure_app/presentation/view/orders/order_list/order_list_page.dart';
import 'package:pick_departure_app/presentation/view/orders/order_preparation/order_preparation_page.dart';
import 'package:pick_departure_app/presentation/view/products/product_list_page.dart';
import 'package:pick_departure_app/presentation/view/splash/splash_page.dart';

class NavigationRoutes {
  static const INITIAL_ROUTE = "/";

  static const HOME_ROUTE = "/home";
  static const ORDERS_ROUTE = "/orders";
  static const PRODUCTS_ROUTE = "/productos";
  static const PICKING_ROUTE = "/picking";

  static const _ORDER_DETAIL_PATH = "orderDetail";
  static const ORDER_DETAIL_ROUTE = "$ORDERS_ROUTE/$_ORDER_DETAIL_PATH";

  static const _NEW_ORDER_PATH = "newOrder";
  static const NEW_ORDER_ROUTE = "$ORDERS_ROUTE/$_NEW_ORDER_PATH";

  static const _ORDER_PREPARATION_PATH = "orderPreparation";
  static const ORDER_PREAPARATION_ROUTE =
      "$ORDERS_ROUTE/$_ORDER_DETAIL_PATH/$_ORDER_PREPARATION_PATH";

  static const _PRODUCT_DETAIL_PATH = "productDetail";
  static const PRODUCT_DETAIL_ROUTE = "$PRODUCTS_ROUTE/$_PRODUCT_DETAIL_PATH";
}

final GoRouter router = GoRouter(
  initialLocation: NavigationRoutes.INITIAL_ROUTE,
  routes: [
    GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const SplashPage(),
    ),
    StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) => HomePage(
              navigationShell: navigationShell,
            ),
        branches: [
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
              path: NavigationRoutes.PRODUCTS_ROUTE,
              builder: (context, state) =>
                  const ProductsListPage(reloadProductList: reloadProductList),
            )
          ]),
        ]),
  ],
);

void reloadProductList() {
  // ignore: unused_element
  setState() {}
}
