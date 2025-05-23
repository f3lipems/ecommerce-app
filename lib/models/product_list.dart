import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:ecomm/models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProductList with ChangeNotifier {
  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  String _token;
  String _userId;
  List<Product> _items = [];

  final _baseUrl = 'https://ecomm-flutterlab-default-rtdb.firebaseio.com';

  List<Product> get items => [..._items];
  List<Product> get favoriteItems => [..._items].where((product) => product.isFavorite).toList();

  Future<void> loadProducts() async {
    final response = await http.get(Uri.parse('$_baseUrl/products.json?auth=$_token'));
    if (response.body == 'null') {
      return Future.value();
    }
    Map<String, dynamic> data = json.decode(response.body);

    final favoritesResponse = await http.get(
      Uri.parse('$_baseUrl/userFavorites/$_userId.json?auth=$_token'),
    );
    Map<String, dynamic> favoritesData = favoritesResponse.body.isEmpty ? {} : json.decode(favoritesResponse.body);

    _items.clear();
    if (data.isNotEmpty) {
      data.forEach((productId, productData) {
        final isFavorite =  favoritesData[productId] ?? false;
        _items.add(Product(
          id: productId,
          name: productData['name'],
          price: productData['price'],
          description: productData['description'],
          imageUrl: productData['imageUrl'],
          isFavorite: isFavorite,
        ));
      });
      notifyListeners();
    }
  }

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

  Future<void> addProduct(Product product) async {
    final postResponse = await http.post(
      Uri.parse('$_baseUrl/products.json?auth=$_token'),
      body: json.encode(
        {
          'name': product.name,
          'price': product.price,
          'description': product.description,
          'imageUrl': product.imageUrl,
        },
      ),
    );

    _items.add(Product(
      id: json.decode(postResponse.body)['name'],
      name: product.name,
      price: product.price,
      description: product.description,
      imageUrl: product.imageUrl,
      isFavorite: product.isFavorite,
    ));
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      final postResponse = await http.patch(
        Uri.parse('$_baseUrl/products/${product.id}.json?auth=$_token'),
        body: json.encode(
          {
            'name': product.name,
            'price': product.price,
            'description': product.description,
            'imageUrl': product.imageUrl,
          },
        ),
      );
      _items[index] = product;
      notifyListeners();
    }

    return Future.value();
  }

  Future<void> updateProductFavorite(Product product) async {
    final index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      try {
        notifyListeners();

        final patchResponse = await http.put(
          Uri.parse('$_baseUrl/userFavorites/$_userId/${product.id}.json?auth=$_token'),
          body: json.encode(product.isFavorite),
        );
        _items[index] = product;

        if (patchResponse.statusCode >= 400) {
          product.isFavorite = !product.isFavorite;
          notifyListeners();
          throw const HttpException('Não foi possível atualizar o produto como favorito.');
        }
      } catch (e) {
        product.isFavorite = !product.isFavorite;
        notifyListeners();
        throw const HttpException('Não foi possível atualizar o produto como favorito.');
      }
    }

    return Future.value();
  }

  Future<void> deleteProduct(Product product) async {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final deleteResponse = await http.delete(
        Uri.parse('$_baseUrl/products/${product.id}.json?auth=$_token'),
      );

      if (deleteResponse.statusCode >= 400) {
        _items.insert(index, product);
        notifyListeners();

        throw const HttpException('Não foi possível excluir o produto.');
      }
    }
  }

  int get itemsCount {
    return _items.length;
  }
}
