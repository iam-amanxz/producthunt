import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/create_product_usecase.dart';

part 'products_create_event.dart';
part 'products_create_state.dart';

class ProductsCreatePageBloc
    extends Bloc<ProductCreatePageEvent, ProductCreatePageState> {
  final CreateProductUsecase _createProduct;

  ProductsCreatePageBloc({
    required CreateProductUsecase createProduct,
  })  : _createProduct = createProduct,
        super(ProductCreateInitial()) {
    on<CreateProductEvent>((event, emit) async {
      emit(ProductCreateLoading());
      final result = await _createProduct(event.params);
      result.fold(
        (error) => emit(ProductCreateFailure(error.message)),
        (_) => emit(ProductCreateSuccess()),
      );
    });
  }
}
