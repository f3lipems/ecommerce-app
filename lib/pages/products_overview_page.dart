import 'package:ecomm/models/product.dart';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class ProductsOverviewPage extends StatelessWidget {
  ProductsOverviewPage({super.key});

  final List<Product> loadedProducts = dummyProducts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: loadedProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (ctx, idx) => Text(loadedProducts[idx].title),
        ),
      ),
    );
  }
}