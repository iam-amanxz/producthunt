import 'package:flutter/material.dart';
import 'package:producthunt/core/theme/app_palette.dart';

import '../../domain/entities/product_entity.dart';
import 'product_image_with_rating_and_color.dart';

class ProductCardExtended extends StatelessWidget {
  const ProductCardExtended({
    super.key,
    required this.product,
    required this.onDeletePressed,
    required this.onCloseView,
  });

  final ProductEntity product;
  final void Function() onDeletePressed;
  final void Function() onCloseView;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Center(
        child: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        onDeletePressed();
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: AppPalette.codexGrey,
                      ),
                      onPressed: () {
                        onCloseView();
                      },
                    ),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 1,
                child: ProductImageWithRatingAndColor(product: product),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(15),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (product.brandName != null &&
                        product.brandName!.isNotEmpty)
                      Container(
                        color: AppPalette.greigeViolet,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 3,
                        ),
                        child: Text(
                          product.brandName!,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    if (product.brandName != null &&
                        product.brandName!.isNotEmpty)
                      const SizedBox(height: 5),
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF22223B),
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.lime,
                        decorationThickness: 2.5,
                      ),
                    ),
                    if (product.description != null &&
                        product.brandName!.isNotEmpty)
                      const SizedBox(height: 5),
                    if (product.description != null &&
                        product.brandName!.isNotEmpty)
                      ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxHeight: 100,
                        ),
                        child: IntrinsicHeight(
                          child: SingleChildScrollView(
                            child: Text(
                              product.description!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: AppPalette.codexGrey,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
