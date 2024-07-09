import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/error/failure.dart';
import '../repositories/product_repository.dart';

class ExportProductsUsecase implements BaseUseCase<void, NoParams> {
  final ProductRepository productRepository;
  ExportProductsUsecase(this.productRepository);

  @override
  Future<Either<Failure, void>> call(NoParams _) async {
    return await productRepository.export();
  }
}
