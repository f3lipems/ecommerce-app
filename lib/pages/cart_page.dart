import 'package:ecomm/componensts/cart_item.dart';
import 'package:ecomm/models/cart.dart';
import 'package:ecomm/models/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Cart cart = Provider.of(context);
    final items = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 25,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total: ',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    label: Text(
                      'R\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  BuyButton(cart: cart)
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (ctx, idx) => CartItemWidget(cartItem: items[idx]),
            ),
          ),
        ],
      ),
    );
  }
}

class BuyButton extends StatefulWidget {
  const BuyButton({
    super.key,
    required this.cart,
  });

  final Cart cart;

  @override
  State<BuyButton> createState() => _BuyButtonState();
}

class _BuyButtonState extends State<BuyButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const CircularProgressIndicator()
        : TextButton(
            style: TextButton.styleFrom(
              textStyle: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
            ),
            onPressed: widget.cart.itemsCount == 0 ? null : () async {
              setState(() => _isLoading = true);
              await Provider.of<OrderList>(context, listen: false).addOrder(widget.cart);
              setState(() => _isLoading = false);
              widget.cart.clear();
            },
            child: const Text('Comprar'),
          );
  }
}
