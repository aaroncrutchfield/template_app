import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:template_app/counter/view/counter_page.dart';

part 'app_router.gr.dart';

@singleton
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Home route
    AutoRoute(
      page: CounterRoute.page,
      path: '/',
      initial: true,
    ),
  ];
}
