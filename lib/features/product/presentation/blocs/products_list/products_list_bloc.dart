import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/usecase.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/delete_product_usecase.dart';
import '../../../domain/usecases/export_products_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import '../../../domain/usecases/import_products_usecase.dart';

part 'products_list_event.dart';
part 'products_list_state.dart';

class ProductsListPageBloc
    extends Bloc<ProductsListPageEvent, ProductsListPageState> {
  final GetProductsUsecase _getProducts;
  final DeleteProductUsecase _deleteProduct;
  final ExportProductsUsecase _exportProducts;
  final ImportProductsUsecase _importProducts;

  ProductsListPageBloc({
    required GetProductsUsecase getProducts,
    required DeleteProductUsecase deleteProduct,
    required ExportProductsUsecase exportProducts,
    required ImportProductsUsecase importProducts,
  })  : _getProducts = getProducts,
        _deleteProduct = deleteProduct,
        _exportProducts = exportProducts,
        _importProducts = importProducts,
        super(const LoadProductsInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(const LoadProductsLoading());
      final result = await _getProducts(event.query);
      result.fold(
        (error) => emit(LoadProductsFailure(error.message)),
        (products) => emit(LoadProductsSuccess(products)),
      );
    });
    on<DeleteProductEvent>((event, emit) async {
      emit(const DeleteProductLoading());
      final result = await _deleteProduct(event.id);
      result.fold(
        (error) => emit(DeleteProductFailure(error.message)),
        (_) {
          emit(const DeleteProductSuccess());
          add(const LoadProductsEvent());
        },
      );
    });
    on<ExportProductsEvent>((event, emit) async {
      emit(const ExportProductsLoading());
      final result = await _exportProducts(NoParams());
      result.fold(
        (error) => emit(ExportProductsFailure(error.message)),
        (_) => emit(const ExportProductsSuccess()),
      );
    });
    on<ImportProductsEvent>((event, emit) async {
      emit(const ImportProductsLoading());
      final result = await _importProducts(NoParams());
      result.fold(
        (error) => emit(ImportProductsFailure(error.message)),
        (_) {
          emit(const ImportProductsSuccess());
          add(const LoadProductsEvent());
        },
      );
    });
  }
}
