import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/theme/theme.dart';
import 'features/product/presentation/blocs/products_create/products_create_bloc.dart';
import 'features/product/presentation/blocs/products_list/products_list_bloc.dart';
import 'init_dependencies.dart';
import 'router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<ProductsListPageBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<ProductsCreatePageBloc>(),
        )
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: AppRouter().config(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      title: "ProductHunt",
    );
  }
}
