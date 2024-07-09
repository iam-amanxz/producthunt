part of 'products_create_bloc.dart';

@immutable
sealed class ProductCreatePageState {}

final class ProductCreateInitial extends ProductCreatePageState {}

final class ProductCreateLoading extends ProductCreatePageState {}

final class ProductCreateSuccess extends ProductCreatePageState {}

final class ProductCreateFailure extends ProductCreatePageState {
  final String message;

  ProductCreateFailure(this.message);
}
