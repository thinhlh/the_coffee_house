import 'package:flutter/material.dart';

import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/services/firestore_products.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Products.fromList(this._products);

  ///Only used for the first time when init and show blank screen in Wrapper
  Future<void> fetchProducts() {
    return FireStoreProducts()
        .firestore
        .collection('products')
        .get()
        .then((value) => this._products = value.docs.map((e) {
              Map<String, dynamic> json = e.data();
              json['id'] = e.id;
              return Product.fromJson(json);
            }).toList());
  }

  List<Product> getProductsByCategory(String categoryId) =>
      _products.where((product) => product.categoryId == categoryId).toList();

  Product getProductById(String id) {
    return _products.firstWhere(
      (product) => product.id == id,
      orElse: () => null,
    );
  }

  Future<int> getNumberOfProductsPerCategory(String categoryId) async {
    return _products
        .where((product) => product.categoryId == categoryId)
        .toList()
        .length;
  }

  List<Product> searchProductsByTitle(String title) {
    return _products
        .where((product) =>
            product.title.trim().toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  Future<void> addProduct(Product product) async {
    try {
      final addedProduct = await FireStoreProducts().add(product);
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final index = _products.indexWhere((product) => product.id == id);
    if (index < 0) return;

    try {
      await FireStoreProducts().update(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String id, BuildContext context) async {
    final index = _products.indexWhere((element) => element.id == id);
    Product tempProduct = _products[index];
    try {
      _products.removeAt(index);
      notifyListeners();
      await FireStoreProducts().delete(id);
    } catch (error) {
      _products.insert(index, tempProduct);
      _products = null;
      notifyListeners();
      throw (error);
    }
  }
}
