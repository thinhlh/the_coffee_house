import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:the_coffee_house/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  List<Product> getProductsByCategory(String categoryId) =>
      _products.where((product) => product.categoryId == categoryId).toList();

  Product getProductById(String id) =>
      (id == null) ? null : _products.firstWhere((product) => product.id == id);

  int getNumberOfProductsPerCategory(String categoryId) => _products
      .where((product) => product.categoryId == categoryId)
      .toList()
      .length;

  List<Product> getProductsByTitle(String title) {
    return _products
        .where((product) =>
            product.title.trim().toLowerCase().contains(title.toLowerCase()))
        .toList();
  }

  Future<List<Product>> fetchProducts() async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/products.json';

    try {
      var response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);
      List<Product> loadedProduct = [];

      extractedData.forEach((key, value) {
        loadedProduct.add(Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            categoryId: value['categoryId']));
      });

      _products = loadedProduct;
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw (error);
    }
    return [..._products];
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/products.json';

    try {
      http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'categoryId': product.categoryId,
        }),
      )..then((response) {
          product = Product(
            id: json.decode(response.body)['name'],
            title: product.title,
            description: product.description,
            price: product.price,
            imageUrl: product.imageUrl,
            categoryId: product.categoryId,
          );
          _products.add(product);
          notifyListeners();
        });
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/products/';

    final index = _products.indexWhere((product) => product.id == id);
    if (index == -1)
      return;
    else
      http.patch(
        url + '$id.json',
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price,
            'imageUrl': newProduct.imageUrl,
            'categoryId': newProduct.categoryId,
          },
        ),
      )..then((response) {
          _products[index] = newProduct;
          notifyListeners();
        });
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/products/';

    try {
      http.delete(url + '$id.json').then(
        (response) {
          final index = _products.indexWhere((element) => element.id == id);
          Product tempProduct = _products[index];
          _products.removeAt(index);

          notifyListeners();
          if (response.statusCode >= 400) {
            _products.insert(index, tempProduct);
            notifyListeners();
          } else {}
          tempProduct = null;
        },
      );
    } catch (error) {
      //TODO handling error
      throw (error);
    }
  }
}
