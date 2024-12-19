import 'dart:convert';
import 'dart:math';
import 'package:ecomm/data/dummy_data.dart';
import 'package:ecomm/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  final List<Product> _items = dummyProducts;
  final _baseUrl = 'https://ecomm-flutterlab-default-rtdb.firebaseio.com';

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => [..._items].where((product) => product.isFavorite).toList();

  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data.containsKey('id');

    final product = Product(
      id: hasId ? data['id'] as String : Random().nextDouble().toString(),
      name: data['name'] as String,
      price: data['price'] as double,
      description: data['description'] as String,
      imageUrl: data['imageUrl'] as String,
    );
    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  Future<void> addProduct(Product product) {
    final postFuture = http.post(
      Uri.parse('$_baseUrl/products.json'),
      body: json.encode(
        {
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'isFavorite': product.isFavorite,
        },
      ),
    );

    return postFuture.then<void>((response) {
      _items.add(Product(
        id: json.decode(response.body)['name'],
        name: product.name,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ));
      notifyListeners();
    });
  }

  Future<void> updateProduct(Product product) {
    final index = _items.indexWhere((prod) => prod.id == product.id);
    if (index >= 0) {
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  void deleteProduct(Product product) {
    _items.removeWhere((prod) => prod.id == product.id);
    notifyListeners();
  }

  int get itemsCount {
    return _items.length;
  }
}
