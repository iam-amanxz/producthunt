import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class DeleteProductUsecase implements BaseUseCase<void, String> {
  final ProductRepository productRepository;
  DeleteProductUsecase(this.productRepository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await productRepository.delete(id);
  }
}
