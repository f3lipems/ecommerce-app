import 'dart:convert';
import 'package:ecomm/models/cart_item.dart';
import 'package:ecomm/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:ecomm/models/cart.dart';
import 'package:ecomm/models/order.dart';
import 'package:flutter/material.dart';

class OrderList with ChangeNotifier {
  static const _baseUrl = 'https://ecomm-flutterlab-default-rtdb.firebaseio.com';

  List<Order> _orders = [];

  List<Order> get items => [..._orders];

  int get itemsCount => _orders.length;

  Future<void> loadOrders() async {
    final response = await http.get(Uri.parse('$_baseUrl/orders.json'));
    if (response.body == 'null') {
      return Future.value();
    }
    _orders.clear();

    Map<String, dynamic> data = jsonDecode(response.body);

    if (data.isNotEmpty) {
      data.forEach((orderId, orderData) {
        _orders.add(Order(
          id: orderId,
          date: DateTime.parse(orderData['date']),
          amount: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((product) {
            return CartItem(
              id: product['id'],
              productId: product['productId'],
              name: product['name'],
              quantity: product['quantity'],
              price: product['price'],
            );
          }).toList(),
        ));
      });
      notifyListeners();
    }
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final dateIso = DateTime.now().toIso8601String();
    final productsMap = cart.items.values
        .map((cartItem) => {
              'id': cartItem.id,
              'productId': cartItem.productId,
              'name': cartItem.name,
              'quantity': cartItem.quantity,
              'price': cartItem.price,
            })
        .toList();

    final postResponse = await http.post(
      Uri.parse('$_baseUrl/orders.json'),
      body: json.encode(
        {
          'total': cart.totalAmount,
          'date': dateIso,
          'products': productsMap,
        },
      ),
    );

    if (postResponse.statusCode != 200) {
      throw Exception('Erro ao cadastrar pedido');
    }

    final id = json.decode(postResponse.body)['name'] as String;

    _orders.insert(
        0,
        Order(
          id: id,
          amount: cart.totalAmount,
          date: date,
          products: cart.items.values.toList(),
        ));
    notifyListeners();
  }
}
