import 'package:camera/camera.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/usecase.dart';
import '../../../../core/error/failure.dart';
import '../entities/product_entity.dart';
import '../repositories/product_repository.dart';

class CreateProductUsecase
    implements BaseUseCase<ProductEntity, CreateProductParams> {
  final ProductRepository productRepository;
  CreateProductUsecase(this.productRepository);

  @override
  Future<Either<Failure, ProductEntity>> call(
      CreateProductParams params) async {
    return await productRepository.create(params);
  }
}

class CreateProductParams {
  final String name;
  final int rating;
  final XFile image;
  final String? description;
  final String? brandName;
  final String? color;

  const CreateProductParams({
    required this.name,
    required this.rating,
    required this.image,
    this.description,
    this.brandName,
    this.color,
  });

  @override
  String toString() {
    return 'CreateProductParams(name: $name, rating: $rating, image: $image, description: $description, brandName: $brandName, color: $color)';
  }
}
