import 'dart:math';

import 'package:ecomm/data/dummy_data.dart';
import 'package:ecomm/models/product.dart';
import 'package:flutter/material.dart';

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => [..._items].where((product) => product.isFavorite).toList();

  void addProduct(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void addProductFromData(Map<String, Object> data) {
    final _newProduct = Product(
      id: Random().nextDouble().toString(),
      name: data['name'] as String,
      price: data['price'] as double,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
    );
    addProduct(_newProduct);
  }

  int get itemsCount {
    return _items.length;
  }
}