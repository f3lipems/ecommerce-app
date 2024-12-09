import 'package:ecomm/componensts/product_grid.dart';
import 'package:ecomm/models/product_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum FilterOptions {
  Favorite,
  All,
}

class ProductsOverviewPage extends StatefulWidget {
  const ProductsOverviewPage({super.key});

  @override
  State<ProductsOverviewPage> createState() => _ProductsOverviewPageState();
}

class _ProductsOverviewPageState extends State<ProductsOverviewPage> {
  bool _showFavoriteOnly = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Store'),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorite) {
                    _showFavoriteOnly = true;
                  } else {
                    _showFavoriteOnly = false;
                  }
                });
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
      body: ProductGrid(showFavoriteOnly: _showFavoriteOnly),
    );
  }
}
