import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class GetProductsUsecase implements BaseUseCase<List<ProductEntity>, String?> {
  final ProductRepository productRepository;
  GetProductsUsecase(this.productRepository);

  @override
  Future<Either<Failure, List<ProductEntity>>> call(String? query) async {
    return await productRepository.getAll(query);
  }
}
