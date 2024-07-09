import 'package:flutter/material.dart';

@immutable
class ProductEntity {
  final String id;
  final String name;
  final int rating;
  final String imageUrl;
  final String? description;
  final String? brandName;
  final String? color;
  final DateTime createdAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.rating,
    required this.imageUrl,
    this.description,
    this.brandName,
    this.color,
    required this.createdAt,
  });
}
