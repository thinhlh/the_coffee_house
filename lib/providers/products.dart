import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/products_api.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  Products.fromList(this._products);

  ///Only used for the first time when init and show blank screen in Wrapper
  Future<List<Product>> fetchProducts() {
    return ProductsAPI()
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

  List<Product> searchProducts(String title) {
    return _products
        .where((product) =>
            product.title.trim().toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  Future<void> addProduct(Product product, bool isLocalImage) async {
    try {
      await ProductsAPI().addProduct(product, isLocalImage);
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateProduct(Product newProduct, bool isLocalImage) async {
    final index =
        _products.indexWhere((product) => product.id == newProduct.id);
    if (index < 0) return;

    try {
      await ProductsAPI().updateProduct(newProduct, isLocalImage);
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
      await ProductsAPI().delete(id);
    } catch (error) {
      _products.insert(index, tempProduct);
      _products = null;
      notifyListeners();
      throw (error);
    }
  }
}
