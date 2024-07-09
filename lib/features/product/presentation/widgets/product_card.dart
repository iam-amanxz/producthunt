import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';
import 'product_image_with_rating_and_color.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.product,
    required this.aspectRatio,
    required this.onViewDetails,
  });

  final ProductEntity product;
  final double aspectRatio;
  final void Function(ProductEntity) onViewDetails;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        onViewDetails(product);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ProductImageWithRatingAndColor(
                product: product,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF22223B),
            ),
          ),
        ],
      ),
    );
  }
}
