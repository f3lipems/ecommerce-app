import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  @override
  Widget build(BuildContext context) {
    final _priceFocus = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nome'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocus);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Preço'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                textInputAction: TextInputAction.next,
                focusNode: _priceFocus,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'URL da Imagem'),
              ),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Salvar'),
              ),
            ],
          )
        ),
      ),
    );
  }
}