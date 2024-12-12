import 'package:ecomm/componensts/app_drawer.dart';
import 'package:ecomm/componensts/order.dart';
import 'package:ecomm/models/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderList orders = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemCount: orders.itemsCount,
        itemBuilder: (ctx, idx) => OrderWidget(order: orders.items[idx]),
      ),
    );
  }
}
