import 'package:flutter/material.dart';

import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/services/firestore_products.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Products.fromList(this._products);

  List<Product> getProductsByCategory(String categoryId) =>
      _products.where((product) => product.categoryId == categoryId).toList();

  Product getProductById(String id) => _products.firstWhere(
        (product) => product.id == id,
        orElse: () => null,
      );

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

  Future<List<Product>> fetchProducts() async {
    try {
      //_products = await FireStoreProducts().fetchProducts();
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw (error);
    }
    return [..._products];
  }

  Future<void> addProduct(Product product) async {
    try {
      final addedProduct = await FireStoreProducts().addProduct(product);
      _products.add(addedProduct);

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
      await FireStoreProducts().updateProduct(id, newProduct);

      _products[index] = newProduct;
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
      await FireStoreProducts().deleteProduct(id);
    } catch (error) {
      _products.insert(index, tempProduct);
      _products = null;
      notifyListeners();
      throw (error);
    }
  }
}
