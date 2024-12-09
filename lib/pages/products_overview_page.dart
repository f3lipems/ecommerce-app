import 'package:ecomm/componensts/product_grid.dart';
import 'package:ecomm/models/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatelessWidget {
  const ProductsOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                if (selectedValue == FilterOptions.Favorite) {
                  provider.showFavoriteOnly();
                } else {
                  provider.showAll();
                }
              },
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.Favorite,
                      child: Text('Favoritos'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.All,
                      child: Text('Todos'),
                    ),
                  ])
        ],
      ),
      body: const ProductGrid(),
    );
  }
}
