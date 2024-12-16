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

  @override
  Widget build(BuildContext context) {
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
              onFieldSubmitted: (_) {
                FocusScope.of(context).requestFocus(_descriptionFocus);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Descrição'),
              textInputAction: TextInputAction.next,
              focusNode: _descriptionFocus,
              keyboardType: TextInputType.multiline,
              maxLines: 3,
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
            ElevatedButton(
              onPressed: () {},
              child: const Text('Salvar'),
            ),
          ],
        )),
      ),
    );
  }
}
