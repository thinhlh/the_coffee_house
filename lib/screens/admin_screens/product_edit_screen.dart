import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_coffee_house/models/category.dart';

import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/providers/products.dart';

import 'package:the_coffee_house/utils/const.dart' as Constant;

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

class EditProductScreen extends StatefulWidget {
  final String id;
  EditProductScreen(this.id);

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  var editingProduct = Product(
    id: null,
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
    categoryId: '',
  );
  List<Category> categories;
  Map<String, String> initValues;

  final TextEditingController imageController = TextEditingController();
  String currentDropDownCategoryId;

  /// if true => didChangeDependencty assign value to initValues
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if (isInit) {
      categories = Provider.of<Categories>(context, listen: false).categories;
      if (widget.id != null) {
        editingProduct = Provider.of<Products>(context, listen: false)
            .getProductById(widget.id);
        currentDropDownCategoryId = editingProduct.categoryId;
      } else {
        currentDropDownCategoryId = categories.first.id;
      }
      initValues = {
        'title': editingProduct.title,
        'description': editingProduct.description,
        'price': editingProduct.price.toStringAsFixed(0),
        'imageUrl': editingProduct.imageUrl,
      };
      imageController.text = editingProduct.imageUrl;
      isInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    imageController.dispose();
    super.dispose();
  }

  void save() async {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    setState(() => isLoading = true);
    if (editingProduct.id != null) {
      // id is not null => this is the update form
      await Provider.of<Products>(
        context,
        listen: false,
      ).updateProduct(editingProduct.id, editingProduct);
    } else {
      // id is null => this is add form
      Provider.of<Products>(
        context,
        listen: false,
      ).addProduct(editingProduct);
    }
    setState(() => isLoading = false);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Add Product' : editingProduct.title),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: save,
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(Constant.GENERAL_PADDING * 2),
                shrinkWrap: true,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Title'),
                    textInputAction: TextInputAction.next,
                    initialValue: initValues['title'],
                    validator: (value) =>
                        value.isEmpty ? 'Title cannot be null' : null,
                    onSaved: (newValue) => editingProduct = Product(
                      id: editingProduct.id,
                      description: editingProduct.description,
                      price: editingProduct.price,
                      categoryId: editingProduct.categoryId,
                      imageUrl: editingProduct.imageUrl,
                      title: newValue,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    keyboardType: TextInputType.multiline,
                    initialValue: initValues['description'],
                    maxLines: 2,
                    validator: (value) =>
                        value.isEmpty ? 'Description cannot be null' : null,
                    onSaved: (newValue) => editingProduct = Product(
                      id: editingProduct.id,
                      title: editingProduct.title,
                      price: editingProduct.price,
                      categoryId: editingProduct.categoryId,
                      imageUrl: editingProduct.imageUrl,
                      description: newValue,
                    ),
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    initialValue: initValues['price'],
                    validator: (value) =>
                        value.isEmpty ? 'Price cannot be null' : null,
                    onSaved: (newValue) => editingProduct = Product(
                      id: editingProduct.id,
                      title: editingProduct.title,
                      description: editingProduct.description,
                      price: double.parse(newValue),
                      categoryId: editingProduct.categoryId,
                      imageUrl: editingProduct.imageUrl,
                    ),
                  ),
                  DropdownButtonFormField(
                      items: categories.map((category) {
                        return DropdownMenuItem(
                          child: Text(category.title),
                          value: category.id,
                        );
                      }).toList(),
                      value: currentDropDownCategoryId,
                      isExpanded: false,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                      ),
                      validator: (category) {
                        if (category == null) return 'Category cannot be null';
                        return null;
                      },
                      onSaved: (value) => editingProduct = Product(
                            id: editingProduct.id,
                            title: editingProduct.title,
                            price: editingProduct.price,
                            categoryId: value,
                            imageUrl: editingProduct.imageUrl,
                            description: editingProduct.description,
                          ),
                      onChanged: (newValue) {
                        setState(() {
                          currentDropDownCategoryId = newValue;
                        });
                      }),
                  TextFormField(
                      controller: imageController,
                      keyboardType: TextInputType.url,
                      decoration: const InputDecoration(
                        labelText: 'Image Url',
                        isDense: true,
                      ),
                      validator: (value) =>
                          value.isEmpty ? 'Image Url cannot be null' : null,
                      onSaved: (newValue) => editingProduct = Product(
                            id: editingProduct.id,
                            title: editingProduct.title,
                            description: editingProduct.description,
                            price: editingProduct.price,
                            categoryId: editingProduct.categoryId,
                            imageUrl: newValue,
                          ),
                      onFieldSubmitted: (value) => setState(() {})),
                  SizedBox(
                    height: Constant.SIZED_BOX_HEIGHT,
                  ),
                  imageController.text.isEmpty
                      ? SizedBox(
                          height: 0,
                          width: 0,
                        )
                      : SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                          child: Image.network(
                            imageController.text,
                            fit: BoxFit.contain,
                            loadingBuilder: (_, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder:
                                (_, exception, StackTrace stackTrace) => Center(
                              child: Text(
                                'Unable to load the image',
                                style: TextStyle(
                                    fontSize: Constant.TEXT_SIZE,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                  SizedBox(
                    height: Constant.SIZED_BOX_HEIGHT,
                  ),
                  Center(
                    child: ElevatedButton(
                      child: Text('Save'),
                      onPressed: save,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
