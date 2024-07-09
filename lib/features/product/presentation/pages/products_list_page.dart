import 'package:auto_route/auto_route.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:producthunt/core/common/widgets/my_button.dart';
import 'package:producthunt/core/theme/app_palette.dart';

import '../../../../core/common/widgets/app_name.dart';
import '../../../../core/common/widgets/loader.dart';
import '../../../../core/util/show_snackbar.dart';
import '../../../../router.dart';
import '../../domain/entities/product_entity.dart';
import '../blocs/products_list/products_list_bloc.dart';
import '../widgets/product_card.dart';
import '../widgets/product_card_extended.dart';
import '../widgets/search_input.dart';

@RoutePage()
class ProductsListPage extends StatefulWidget {
  const ProductsListPage({super.key});

  @override
  State<ProductsListPage> createState() => _ProductsListPageState();
}

class _ProductsListPageState extends State<ProductsListPage> {
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    context.read<ProductsListPageBloc>().add(const LoadProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsListPageBloc, ProductsListPageState>(
      listenWhen: (prev, current) =>
          stateWhenImportProducts(prev, current) ||
          stateWhenExportProducts(prev, current),
      listener: (context, state) async {
        if (state is ExportProductsSuccess || state is ImportProductsSuccess) {
          final message = state is ExportProductsSuccess
              ? (state).message
              : (state as ImportProductsSuccess).message;
          showSnackbar(context, message);
        }

        if (state is ExportProductsFailure || state is ImportProductsFailure) {
          final message = state is ExportProductsFailure
              ? (state).message
              : (state as ImportProductsFailure).message;
          showSnackbar(context, message, isSuccess: false);
        }
      },
      buildWhen: stateWhenLoadProducts,
      builder: (context, state) {
        return Scaffold(
          appBar: _buildAppBar(state),
          body: _buildBody(state),
        );
      },
    );
  }

  Future<bool> _requestStoragePermission() async {
    final plugin = DeviceInfoPlugin();
    final android = await plugin.androidInfo;
    final permission =
        android.version.sdkInt < 33 ? Permission.storage : Permission.photos;

    if (await permission.request().isGranted) {
      return true;
    } else if (await permission.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await permission.request().isDenied) {
      return false;
    }

    return false;
  }

  AppBar _buildAppBar(ProductsListPageState state) => AppBar(
        title: const AppName(),
        actions: [
          IconButton(
            icon: Icon(!_isSearching ? Icons.search : Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
              if (!_isSearching) {
                context.read<ProductsListPageBloc>().add(
                      const LoadProductsEvent(),
                    );
              }
            },
          ),
          PopupMenuButton(
            onSelected: (value) async {
              if (value == 'create') {
                AutoRouter.of(context).push(const ProductCreateRoute());
              }

              if (value == 'export' || value == 'import') {
                if (!await _requestStoragePermission() && mounted) {
                  showSnackbar(
                    context,
                    "Storage permission denied",
                    isSuccess: false,
                  );
                  return;
                }

                context.read<ProductsListPageBloc>().add(
                      value == 'export'
                          ? const ExportProductsEvent()
                          : const ImportProductsEvent(),
                    );
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem(
                  value: 'create',
                  child: Text("Create New"),
                ),
                PopupMenuItem(
                  value: 'export',
                  child: Text("Export"),
                ),
                PopupMenuItem(
                  value: 'import',
                  child: Text("Import"),
                ),
              ];
            },
          ),
        ],
      );

  Widget _buildBody(ProductsListPageState state) {
    if (state is LoadProductsSuccess) {
      final products = state.products;
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            if (_isSearching)
              SearchInput(
                onSearch: (searchTerm) {
                  context.read<ProductsListPageBloc>().add(
                        LoadProductsEvent(query: searchTerm),
                      );
                },
              ),
            if (_isSearching) const SizedBox(height: 20),
            products.isNotEmpty
                ? _buildProductsGridView(products)
                : _buildProductsEmptyView(),
          ],
        ),
      );
    }

    if (state is LoadProductsFailure) {
      return const Center(
        child: Text("Error loading products"),
      );
    }

    return const Loader();
  }

  Widget _buildProductsEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No products found",
            style: TextStyle(
              fontSize: 20,
              color: AppPalette.codexGrey,
            ),
          ),
          const SizedBox(height: 10),
          MyButton(
            onPressed: () =>
                AutoRouter.of(context).push(const ProductCreateRoute()),
            label: "Create New",
          ),
        ],
      ),
    );
  }

  Widget _buildProductsGridView(List<ProductEntity> products) {
    return Expanded(
      child: MasonryGridView.count(
        shrinkWrap: true,
        itemCount: products.length,
        crossAxisCount: 2,
        mainAxisSpacing: 30,
        crossAxisSpacing: 15,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            onViewDetails: (product) {
              showDialog(
                context: context,
                builder: (context) {
                  return ProductCardExtended(
                    product: product,
                    onCloseView: () {
                      Navigator.pop(context);
                    },
                    onDeletePressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => _buildDeleteConfirmation(
                          product.id,
                        ),
                      );
                    },
                  );
                },
              );
            },
            product: product,
            aspectRatio: index % 4 == 0 || index % 4 == 3 ? 4 / 3 : 1,
          );
        },
      ),
    );
  }

  Widget _buildDeleteConfirmation(String productId) {
    return Container(
      color: AppPalette.crownBlue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Are you sure you want to delete this product?",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<ProductsListPageBloc>().add(
                        DeleteProductEvent(productId),
                      );
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.redAccent,
                ),
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppPalette.sauvignon,
                ),
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
