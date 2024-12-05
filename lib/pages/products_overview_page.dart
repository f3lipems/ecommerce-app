import 'package:ecomm/componensts/product_grid.dart';
import 'package:flutter/material.dart';

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
      ),
      body: const ProductGrid(),
    );
  }
}


