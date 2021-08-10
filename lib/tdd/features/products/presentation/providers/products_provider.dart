import 'package:flutter/material.dart';
import 'package:the/tdd/core/base/base_provider.dart';
import 'package:the/tdd/core/usecases/usecase.dart';
import 'package:the/tdd/features/products/domain/entities/category.dart';
import 'package:the/tdd/features/products/domain/entities/product.dart';
import 'package:the/tdd/features/products/domain/usecases/fetch_categories.dart';
import 'package:the/tdd/features/products/domain/usecases/fetch_products.dart';

class ProductsProvider with ChangeNotifier {
  final FetchProducts _fetchProducts;
  final FetchCategories _fetchCategories;

  ProductsProvider(this._fetchProducts, this._fetchCategories);

  List<Product> _products = [];
  List<Product> get products => [..._products];

  List<Category> _categories = [];
  List<Category> get categories => [..._categories];

  Future<void> fetchProducts() async {
    final productsEither = await _fetchProducts(NoParams());
    final categoriesEither = await _fetchCategories(NoParams());

    categoriesEither.fold(
      (failure) => null,
      (categories) => _categories = categories,
    );
    productsEither.fold(
      (failure) => null,
      (products) => _products = products,
    );

    notifyListeners();
  }

  Product getProductById(String id) =>
      products.firstWhere((product) => product.id == id, orElse: () => null);

  List<Product> getProductsByCategory(String categoryId) =>
      products.where((product) => product.categoryId == categoryId).toList();

  int getNumberOfProductsEachCategory(String categoryId) =>
      products.where((product) => product.categoryId == categoryId).length;

  String getCategoryTitleById(String id) =>
      categories.firstWhere((category) => category.id == id).title;

  List<Product> searchProducts(String title) {
    return products
        .where((product) =>
            product.title.trim().toLowerCase().contains(title.toLowerCase()))
        .toList();
  }
}
