import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../core/error/exception.dart';
import '../models/product_model.dart';

abstract interface class ProductLocalDataSource {
  Future<ProductModel> create(ProductModel product);
  Future<void> delete(String id);
  Future<ProductModel> getOne(String id);
  Future<List<ProductModel>> getAll(String? query);
  Future<void> exportAsJson();
  Future<void> importFromJson();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box box;

  ProductLocalDataSourceImpl(this.box);

  static final temporaryProducts = [
    ProductModel(
      brandName: "Samsung",
      name: "Galaxy S24 Ultra",
      description:
          "Speak foreign languages on the spot using Live Translate with Galaxy AI. Unlock the power of convenient communication with near-real-time voice translations right through your Samsung Phone app",
      id: "1",
      rating: 9,
      color: Colors.grey.value.toRadixString(10),
      imageUrl:
          "https://fdn2.gsmarena.com/vv/pics/samsung/samsung-galaxy-s24-ultra-5g-sm-s928-0.jpg",
      createdAt: DateTime.now(),
    ),
    ProductModel(
      brandName: "Adidas",
      name: "ADIDAS BY STELLA MCCARTNEY SPORTSWEAR 2000 SHOES",
      description:
          "Turn your eye toward what's ahead in these forward-thinking shoes from adidas by Stella McCartney. The sandwich mesh upper gives you maximum ventilation, while the durable build delivers just the right support for any activity. The recycled EVA and rubber tooling provide comfort and grip for stable footing. In these shoes for the eco-conscious — they're made with natural and renewable materials — you're officially ready to head out on whatever path is before you. These shoes are made with natural and renewable materials as part of our journey to design out finite resources and help end plastic waste.",
      id: "2",
      rating: 10,
      color: Colors.lime.value.toRadixString(10),
      imageUrl:
          "https://assets.adidas.com/images/w_450,f_auto,q_auto/eff4ac2777ee4179a062e75e127b8424_9366/IF6076_02_standard_hover.jpg",
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: "3",
      brandName: "Guess",
      name: "Guess Men's Silver Analog Stainless Steel Strap Watch | W1305G1",
      description:
          "We offer a wide range of luxury watches that are perfect for any occasion. Our selection of watches includes Fossil, G-Shock, Casio, Omax, Hugo Boss, and more.",
      imageUrl: "https://m.media-amazon.com/images/I/61XN8WP5ujL._SX679_.jpg",
      color: Colors.red.value.toRadixString(10),
      rating: 8,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: "3",
      brandName: "Ecko",
      name: "Ecko Tape Detail Backpack with Adjustable Straps and Zip Closure",
      description:
          "Highly functional and stylish, this backpack will become your all-time travel partner. It is accentuated by tape detail across the front and is well-crafted from durable material. ",
      imageUrl:
          "https://media.centrepointstores.com/i/centrepoint/4833469-LMSN102001-SPS2450424_01-2100.jpg",
      color: Colors.amber.value.toRadixString(10),
      rating: 7,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: "4",
      brandName: "Apple",
      name: "Apple MacBook Pro 14 M3 Pro Retina XDR Laptop",
      description:
          "MacBook Pro blasts forward with the M3, M3 Pro, and M3 Max chips. Built on 3-nanometer technology and featuring an all-new GPU architecture, they’re the most advanced chips ever built for a personal computer. And each one brings more pro performance and capability.",
      imageUrl:
          "https://gait.com.qa/media/catalog/product/c/o/conf-macbookpro14-m3__1.jpg",
      color: Colors.black.value.toRadixString(10),
      rating: 9,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: "5",
      brandName: "Adidas",
      name: "SHOWTHEWAY 2.0 SHOES",
      description:
          "Whether you're stepping out for a morning jog through the neighbourhood or wanting to bring some running inspiration to your everyday wardrobe, lace up in these adidas shoes",
      imageUrl:
          "https://assets.adidas.com/images/w_1880,f_auto,q_auto/190fe9a768fb4a44833505b1f15c14be_9366/IG6549_01_standard.jpg",
      color: Colors.white.value.toRadixString(10),
      rating: 7,
      createdAt: DateTime.now(),
    ),
    ProductModel(
      id: "6",
      brandName: "Azha",
      name: "Azha Black Ruby Eau De Parfum - 100 ml",
      description:
          "Indulge in the enchanting Black Ruby Eau De Parfum, a fragrance that tantalizes the senses. ",
      imageUrl:
          "https://media.centrepointstores.com/i/centrepoint/166699741_01-2100.jpg",
      color: Colors.redAccent.value.toRadixString(10),
      rating: 6,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<ProductModel> create(ProductModel product) {
    box.put(product.id, product.toMap());

    return Future.value(product);
  }

  @override
  Future<void> delete(String id) {
    box.delete(id);
    return Future.value();
  }

  @override
  Future<List<ProductModel>> getAll(String? query) async {
    List<ProductModel> products = [];

    box.read(() {
      for (int i = 0; i < box.length; i++) {
        products.add(ProductModel.fromMap(box.getAt(i)));
      }
    });

    products.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    if (query != null) {
      return Future.value(
        products
            .where((product) =>
                product.name.toLowerCase().contains(query) ||
                (product.description ?? "").toLowerCase().contains(query) ||
                (product.brandName ?? "").toLowerCase().contains(query))
            .toList(),
      );
    }
    return products;
  }

  @override
  Future<ProductModel> getOne(String id) {
    return Future.value(box.get(id));
  }

  @override
  Future<void> exportAsJson() async {
    try {
      final products = await getAll(null);

      if (products.isEmpty) {
        throw const ServerException("No products to export");
      }

      final jsonData = products.map((product) {
        final imageBytes = File(product.imageUrl).readAsBytesSync();
        final base64Image = base64Encode(imageBytes);

        return {
          ...product.toMap(),
          "base64Image": base64Image,
        };
      }).toList();

      await FilePicker.platform.saveFile(
        dialogTitle: "Export Products",
        fileName: "products_${DateTime.now().toIso8601String()}.json",
        bytes: utf8.encode(jsonEncode(jsonData)),
        type: FileType.custom,
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> importFromJson() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );

    if (result == null) {
      throw const ServerException("No file selected");
    }

    File file = File(result.files.single.path!);
    String fileContent = await file.readAsString();
    final importedJsonData = jsonDecode(fileContent);

    List<ProductModel> importedProducts = [];

    for (final product in importedJsonData) {
      final base64Image = product["base64Image"];
      final imageBytes = base64Decode(base64Image);

      final XFile imageFile = XFile.fromData(imageBytes);

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${DateTime.now()}.png';

      await imageFile.saveTo(path);

      importedProducts.add(
        ProductModel.fromMap(product).copyWith(
          imageUrl: path,
        ),
      );
    }

    box.clear();

    for (final product in importedProducts) {
      await create(product);
    }
  }
}
