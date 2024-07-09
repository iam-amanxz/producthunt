// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    ProductCreateRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProductCreatePage(),
      );
    },
    ProductsListRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const ProductsListPage(),
      );
    },
  };
}

/// generated route for
/// [ProductCreatePage]
class ProductCreateRoute extends PageRouteInfo<void> {
  const ProductCreateRoute({List<PageRouteInfo>? children})
      : super(
          ProductCreateRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductCreateRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [ProductsListPage]
class ProductsListRoute extends PageRouteInfo<void> {
  const ProductsListRoute({List<PageRouteInfo>? children})
      : super(
          ProductsListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductsListRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
