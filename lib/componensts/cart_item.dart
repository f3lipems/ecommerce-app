import 'package:ecomm/models/cart_item.dart';
import 'package:flutter/material.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({super.key, required this.cartItem});

  final CartItem cartItem;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: FittedBox(
              child: Text('${cartItem.price}'),
            ),
          ),
        ),
        title: Text(cartItem.name),
        subtitle: Text('Total: r\$ ${cartItem.price * cartItem.quantity}'),
        trailing: Text('${cartItem.quantity}X'),
      ),
    );
  }
}
