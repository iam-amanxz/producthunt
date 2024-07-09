import 'package:auto_route/auto_route.dart';

import 'features/product/presentation/pages/product_create_page.dart';
import 'features/product/presentation/pages/products_list_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: ProductsListRoute.page, initial: true),
        AutoRoute(page: ProductCreateRoute.page),
      ];
}
