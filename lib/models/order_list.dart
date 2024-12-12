import 'dart:math';

import 'package:ecomm/models/cart.dart';
import 'package:ecomm/models/order.dart';
import 'package:flutter/material.dart';

class OrderList with ChangeNotifier{

  List<Order> _orders = [];

  List<Order> get items => [..._orders];

  int get itemsCount => _orders.length;

  void addOrder(Cart cart){
    _orders.insert(0, 
      Order(
        id: Random().nextDouble().toString(),
        amount: cart.totalAmount,
        date: DateTime.now(),
        products: cart.items.values.toList(),
      )
    );
    notifyListeners();
  }
  
}