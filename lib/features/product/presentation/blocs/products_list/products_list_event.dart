part of 'products_list_bloc.dart';

@immutable
sealed class ProductsListPageEvent {
  const ProductsListPageEvent();
}

class LoadProductsEvent extends ProductsListPageEvent {
  final String? query;

  const LoadProductsEvent({this.query});
}

class DeleteProductEvent extends ProductsListPageEvent {
  final String id;

  const DeleteProductEvent(this.id);
}

class ExportProductsEvent extends ProductsListPageEvent {
  const ExportProductsEvent();
}

class ImportProductsEvent extends ProductsListPageEvent {
  const ImportProductsEvent();
}
