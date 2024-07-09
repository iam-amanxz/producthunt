import 'package:flutter/material.dart';

import '../../domain/entities/product_entity.dart';

@immutable
class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.rating,
    required super.imageUrl,
    required super.createdAt,
    super.description,
    super.brandName,
    super.color,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],
      name: map['name'],
      rating: map['rating'],
      imageUrl: map['imageUrl'],
      createdAt: DateTime.parse(map['createdAt']),
      description: (map['description'] ?? ''),
      brandName: (map['brandName'] ?? ''),
      color: (map['color'] ?? ''),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'rating': rating,
      'imageUrl': imageUrl,
      'description': description,
      'brandName': brandName,
      'color': color,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ProductModel copyWith({
    String? id,
    String? name,
    int? rating,
    String? imageUrl,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rating: rating ?? this.rating,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description,
      brandName: brandName,
      color: color,
      createdAt: createdAt,
    );
  }
}
