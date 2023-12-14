import 'package:go_router/go_router.dart';
import 'package:pick_departure_app/presentation/view/splash/splash_page.dart';

class NavigationRoutes {
  // Routes
  static const String INITIAL_ROUTE = "/";
  static const String JOKE_CATEGORIES_ROUTE = "/joke-categories";
  static const String JOKE_DETAIL_ROUTE =
      "$JOKE_CATEGORIES_ROUTE/$_JOKE_DETAIL_PATH";

  // Paths
  static const String _JOKE_DETAIL_PATH = "joke-detail";
}

final GoRouter router = GoRouter(
  initialLocation: NavigationRoutes.INITIAL_ROUTE,
  routes: [
    GoRoute(
      path: NavigationRoutes.INITIAL_ROUTE,
      builder: (context, state) => const SplashPage(),
    ),
    // GoRoute(
    //     path: NavigationRoutes.JOKE_CATEGORIES_ROUTE,
    //     builder: (context, state) => const JokeCategoriesPage(),
    //     routes: [
    //       GoRoute(
    //         path: NavigationRoutes._JOKE_DETAIL_PATH,
    //         builder: (context, state) =>
    //             JokeDetailPage(category: state.extra as String),
    //       )
    //     ])
  ],
);
