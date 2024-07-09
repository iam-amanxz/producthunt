import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

class ProductImageWithRatingAndColor extends StatelessWidget {
  const ProductImageWithRatingAndColor({
    super.key,
    required this.product,
  });

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          product.imageUrl,
          width: double.infinity,
          alignment: Alignment.center,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Image.file(
            File(product.imageUrl),
            width: double.infinity,
            alignment: Alignment.center,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Colors.yellow,
                        size: 20,
                      ),
                      Text(
                        "(${product.rating.toString()})",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF22223B),
                        ),
                      ),
                    ],
                  ),
                ),
                if (product.color != null && product.color!.isNotEmpty)
                  const SizedBox(width: 5),
                if (product.color != null && product.color!.isNotEmpty)
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Color(int.parse(
                        product.color!,
                      )),
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
