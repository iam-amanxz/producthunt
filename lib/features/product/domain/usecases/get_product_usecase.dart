import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class GetProductUsecase implements BaseUseCase<void, String> {
  final ProductRepository productRepository;
  GetProductUsecase(this.productRepository);

  @override
  Future<Either<Failure, void>> call(String id) async {
    return await productRepository.getOne(id);
  }
}
