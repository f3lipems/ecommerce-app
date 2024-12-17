import 'dart:math';

import 'package:ecomm/models/product.dart';
import 'package:flutter/material.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({super.key});

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();
  final _imageUrlController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(_updateImageUrl);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(_updateImageUrl);
    _imageUrlFocus.dispose();
  }

  void _updateImageUrl() {
    setState(() {});
  }

  bool isValidImageUrl(String url) {
    final urlPattern = RegExp(
      r'http(s)?://'
      r'(www\.)?'
      r'([a-zA-Z]|[0-9]|[$-_@.&+]|[!*\\(\\),]|(?:%[0-9a-fA-F][0-9a-fA-F]))+',
    );
    bool isValidePath = Uri.tryParse(url)?.hasAbsolutePath ?? false;
    bool endsWithImage =
        url.toLowerCase().endsWith('.png') || url.toLowerCase().endsWith('.jpg') || url.toLowerCase().endsWith('.jpeg');

    return urlPattern.hasMatch(url) && isValidePath && endsWithImage;
  }

  void _submitForm() {
    final _isValid = _formKey.currentState?.validate() ?? false;
    if (!_isValid) {
      return;
    }

    _formKey.currentState?.save();

    final newProduct = Product(
      id: Random().nextDouble().toString(),
      name: _formData['name'] as String,
      price: _formData['price'] as double,
      description: _formData['description'] as String,
      imageUrl: _formData['imageUrl'] as String,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Formulário de Produto'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Nome'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_priceFocus);
                  },
                  onSaved: (name) => _formData['name'] = name ?? '',
                  validator: (nameField) {
                    final nameValue = nameField ?? '';
                    if (nameValue.trim().isEmpty) {
                      return 'Informe um nome válido';
                    }
                    if (nameValue.length < 3) {
                      return 'Nome precisa ter no mínimo 3 caracteres';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Preço'),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textInputAction: TextInputAction.next,
                  focusNode: _priceFocus,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocus);
                  },
                  onSaved: (price) => _formData['price'] = double.parse(price ?? '0'),
                  validator: (priceField) {
                    final priceValue = priceField ?? '';
                    final priceParsed = double.tryParse(priceValue) ?? -1;
                    if(priceParsed <= 0) {
                      return 'Informe um preço válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  textInputAction: TextInputAction.next,
                  focusNode: _descriptionFocus,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  onSaved: (description) => _formData['description'] = description ?? '',
                  validator: (descriptionField) {
                    final descriptionValue = descriptionField ?? '';
                    if (descriptionValue.trim().isEmpty) {
                      return 'Informe uma descrição válida';
                    }
                    if (descriptionValue.length < 10) {
                      return 'Descrição precisa ter no mínimo 10 caracteres';
                    }
                    return null;
                  } 
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(labelText: 'URL da Imagem'),
                        textInputAction: TextInputAction.done,
                        focusNode: _imageUrlFocus,
                        keyboardType: TextInputType.url,
                        controller: _imageUrlController,
                        onFieldSubmitted: (_) => _submitForm(),
                        onSaved: (imageUrl) => _formData['imageUrl'] = imageUrl ?? '',
                        validator: (imageUrlField) {
                          final imageUrlValue = imageUrlField ?? '';
                          if (!isValidImageUrl(imageUrlValue)) {
                            return 'Informe uma URL válida';
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10, left: 10),
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                      child: _imageUrlController.text.isEmpty
                          ? const Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                              ),
                            )
                          : FittedBox(
                              child: Image.network(
                                _imageUrlController.text,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
