import 'package:ecomm/componensts/app_drawer.dart';
import 'package:ecomm/componensts/order.dart';
import 'package:ecomm/models/order_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _refreshOrders(BuildContext context) {
      return Provider.of<OrderList>(context, listen: false).loadOrders();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<OrderList>(context, listen: false).loadOrders(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.error != null) {
            return const Center(
              child: Text('Ocorreu um erro!'),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshOrders(context),
              child: Consumer<OrderList>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemCount: orders.itemsCount,
                  itemBuilder: (ctx, idx) => OrderWidget(order: orders.items[idx]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
