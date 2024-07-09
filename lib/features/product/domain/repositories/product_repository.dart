import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';
import '../usecases/create_product_usecase.dart';

abstract interface class ProductRepository {
  Future<Either<Failure, ProductEntity>> create(
    CreateProductParams params,
  );
  Future<Either<Failure, List<ProductEntity>>> getAll(String? query);
  Future<Either<Failure, ProductEntity>> getOne(String id);
  Future<Either<Failure, void>> delete(String id);
  Future<Either<Failure, void>> export();
  Future<Either<Failure, void>> import();
}
