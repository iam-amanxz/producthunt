part of 'products_create_bloc.dart';

@immutable
sealed class ProductCreatePageEvent {
  const ProductCreatePageEvent();
}

class CreateProductEvent extends ProductCreatePageEvent {
  final CreateProductParams params;

  const CreateProductEvent({required this.params});
}
