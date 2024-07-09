part of 'init_dependencies.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  Hive.defaultDirectory = (await getApplicationDocumentsDirectory()).path;

  serviceLocator.registerLazySingleton(
    () => Hive.box(name: 'products'),
  );

  _initProduct();
}

void _initProduct() {
  // Data sources
  serviceLocator
    ..registerLazySingleton<ProductLocalDataSource>(
      () => ProductLocalDataSourceImpl(
        serviceLocator(),
      ),
    )
    // Repository
    ..registerFactory<ProductRepository>(
      () => ProductRepositoryImpl(
        serviceLocator(),
      ),
    )
    // Use cases
    ..registerFactory(
      () => GetProductUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => GetProductsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => CreateProductUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => DeleteProductUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ExportProductsUsecase(
        serviceLocator(),
      ),
    )
    ..registerFactory(
      () => ImportProductsUsecase(
        serviceLocator(),
      ),
    )
    // Bloc
    ..registerLazySingleton(
      () => ProductsListPageBloc(
        getProducts: serviceLocator<GetProductsUsecase>(),
        deleteProduct: serviceLocator<DeleteProductUsecase>(),
        exportProducts: serviceLocator<ExportProductsUsecase>(),
        importProducts: serviceLocator<ImportProductsUsecase>(),
      ),
    )
    ..registerLazySingleton(
      () => ProductsCreatePageBloc(
        createProduct: serviceLocator<CreateProductUsecase>(),
      ),
    );
}
