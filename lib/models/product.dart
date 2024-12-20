import 'package:ecomm/models/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite(BuildContext context) {
    isFavorite = !isFavorite;
    Provider.of<ProductList>(context, listen: false).updateProductFavorite(this);
    notifyListeners();
  }
}
