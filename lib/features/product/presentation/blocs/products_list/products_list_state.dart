part of 'products_list_bloc.dart';

@immutable
sealed class ProductsListPageState {
  const ProductsListPageState();
}

// Load products
final class LoadProductsInitial extends ProductsListPageState {
  const LoadProductsInitial();
}

final class LoadProductsLoading extends ProductsListPageState {
  const LoadProductsLoading();
}

final class LoadProductsSuccess extends ProductsListPageState {
  final List<ProductEntity> products;

  const LoadProductsSuccess(this.products);
}

final class LoadProductsFailure extends ProductsListPageState {
  final String message;

  const LoadProductsFailure(this.message);
}

// Delete products
final class DeleteProductInitial extends ProductsListPageState {
  const DeleteProductInitial();
}

final class DeleteProductLoading extends ProductsListPageState {
  const DeleteProductLoading();
}

final class DeleteProductSuccess extends ProductsListPageState {
  const DeleteProductSuccess();
}

final class DeleteProductFailure extends ProductsListPageState {
  final String message;

  const DeleteProductFailure(this.message);
}

// Import products
final class ImportProductsInitial extends ProductsListPageState {
  const ImportProductsInitial();
}

final class ImportProductsLoading extends ProductsListPageState {
  const ImportProductsLoading();
}

final class ImportProductsSuccess extends ProductsListPageState {
  final String message;
  const ImportProductsSuccess() : message = "Products imported successfully";
}

final class ImportProductsFailure extends ProductsListPageState {
  final String message;
  const ImportProductsFailure(this.message);
}

// Export products
final class ExportProductsInitial extends ProductsListPageState {
  const ExportProductsInitial();
}

final class ExportProductsLoading extends ProductsListPageState {
  const ExportProductsLoading();
}

final class ExportProductsSuccess extends ProductsListPageState {
  final String message;
  const ExportProductsSuccess() : message = "Products exported successfully";
}

final class ExportProductsFailure extends ProductsListPageState {
  final String message;
  const ExportProductsFailure(this.message);
}

bool Function(ProductsListPageState prev, ProductsListPageState current)
    stateWhenLoadProducts = (prev, current) {
  return current is LoadProductsSuccess ||
      current is LoadProductsLoading ||
      current is LoadProductsInitial ||
      current is LoadProductsFailure;
};

bool Function(ProductsListPageState prev, ProductsListPageState current)
    stateWhenDeleteProduct = (prev, current) {
  return current is DeleteProductSuccess ||
      current is DeleteProductLoading ||
      current is DeleteProductInitial ||
      current is DeleteProductFailure;
};

bool Function(ProductsListPageState prev, ProductsListPageState current)
    stateWhenImportProducts = (prev, current) {
  return current is ImportProductsSuccess ||
      current is ImportProductsLoading ||
      current is ImportProductsInitial ||
      current is ImportProductsFailure;
};

stateWhenExportProducts(
    ProductsListPageState prev, ProductsListPageState current) {
  return current is ExportProductsSuccess ||
      current is ExportProductsLoading ||
      current is ExportProductsInitial ||
      current is ExportProductsFailure;
}
