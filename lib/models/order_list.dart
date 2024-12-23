import 'dart:convert';
import 'package:ecomm/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:ecomm/models/cart.dart';
import 'package:ecomm/models/order.dart';
import 'package:flutter/material.dart';

class OrderList with ChangeNotifier {
  final _baseUrl = 'https://ecomm-flutterlab-default-rtdb.firebaseio.com';

  List<Order> _orders = [];

  List<Order> get items => [..._orders];

  int get itemsCount => _orders.length;

  Future<void> addOrder(Cart cart) async {
    final url = '$_baseUrl/orders.json';
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

    print(url);

    final postResponse = await http.post(
      Uri.parse(url),
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
