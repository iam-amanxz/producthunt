import 'package:fpdart/fpdart.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/exception.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../../domain/usecases/create_product_usecase.dart';
import '../datasources/product_local_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductLocalDataSource productLocalDataSource;

  ProductRepositoryImpl(this.productLocalDataSource);

  @override
  Future<Either<Failure, ProductEntity>> create(
      CreateProductParams params) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${DateTime.now()}.png';

    await params.image.saveTo(path);

    final product = ProductModel(
      id: DateTime.now().toIso8601String(),
      name: params.name,
      rating: params.rating,
      imageUrl: path,
      brandName: params.brandName,
      color: params.color,
      description: params.description,
      createdAt: DateTime.now(),
    );

    try {
      final createdProduct = await productLocalDataSource.create(product);
      return right(createdProduct);
    } on ServerException catch (_) {
      return left(Failure('Error creating product'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await productLocalDataSource.delete(id);
      return right(null);
    } on ServerException catch (_) {
      return left(Failure('Error deleting product'));
    }
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getAll(String? query) async {
    try {
      final products = await productLocalDataSource.getAll(query);
      return right(products);
    } on ServerException catch (_) {
      return left(Failure('Error getting products'));
    }
  }

  @override
  Future<Either<Failure, ProductEntity>> getOne(String id) async {
    try {
      final product = await productLocalDataSource.getOne(id);
      return right(product);
    } on ServerException catch (_) {
      return left(Failure('Error getting product'));
    }
  }

  @override
  Future<Either<Failure, void>> export() async {
    try {
      await productLocalDataSource.exportAsJson();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> import() async {
    try {
      await productLocalDataSource.importFromJson();
      return right(null);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
