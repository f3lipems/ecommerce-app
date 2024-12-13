import 'package:ecomm/models/cart.dart';
import 'package:ecomm/models/product.dart';
import 'package:ecomm/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: Consumer<Product>(
          builder: (ctx, product, child) => GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              onPressed: () {
                product.toggleFavorite();
              },
              icon: Icon(product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(
              product.name,
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.secondary,
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Produto adicionado com sucesso!'),
                    duration: const Duration(seconds: 3),
                    action: SnackBarAction(
                      label: 'DESFAZER',
                      onPressed: () {
                        cart.removeSingleItem(product.id);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(AppRoutes.PRODUCT_DETAIL, arguments: product);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
