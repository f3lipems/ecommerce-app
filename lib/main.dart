import 'package:ecomm/models/cart.dart';
import 'package:ecomm/models/order_list.dart';
import 'package:ecomm/models/product_list.dart';
import 'package:ecomm/pages/cart_page.dart';
import 'package:ecomm/pages/product_detail_page.dart';
import 'package:ecomm/pages/products_overview_page.dart';
import 'package:ecomm/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ProductList(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            primary: Colors.purple,
            secondary: Colors.deepOrange,
          ),
          useMaterial3: true,
          fontFamily: 'Lato',
          appBarTheme: AppBarTheme(
            backgroundColor: Theme.of(context).colorScheme.primary,
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            titleTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ),
        home: ProductsOverviewPage(),
        routes: {
          AppRoutes.HOME: (ctx) => const ProductsOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (ctx) => const ProductDetailPage(),
          AppRoutes.CART : (ctx) => const CartPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
