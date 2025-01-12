import 'package:ecomm/models/auth.dart';
import 'package:ecomm/pages/auth_page.dart';
import 'package:ecomm/pages/products_overview_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of<Auth>(context);

    return auth.isAuth ? const ProductsOverviewPage() : const AuthPage();
  }
}