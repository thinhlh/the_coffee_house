import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:the_coffee_house/models/http_exception.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'dart:convert';
import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<String> categoryIdList() =>
      _categories.map((category) => category.id).toList();

  Category getCategoryById(String id) {
    if (id == null) return null;
    return _categories.firstWhere((element) => element.id == id);
  }

  Future<List<Category>> fetchCategories() async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/categories.json';

    try {
      var response = await http.get(url);
      Map<String, dynamic> extractedData = json.decode(response.body);
      final List<Category> loadedCategories = [];

      extractedData.forEach((id, value) {
        loadedCategories.add(
          Category(
            id: id,
            title: value['title'],
            imageUrl: value['imageUrl'],
          ),
        );
      });
      _categories = loadedCategories;
      notifyListeners();
    } catch (error) {
      // TODO handling error
      throw error;
    }
    return [..._categories];
  }

  Future<void> addCategory(Category category) async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/categories.json';
    try {
      var response = await http.post(
        url,
        body: json.encode({
          'title': category.title,
          'imageUrl': category.imageUrl,
        }),
      );

      category = Category(
        id: json.decode(response.body)['name'],
        title: category.title,
        imageUrl: category.imageUrl,
      );

      _categories.add(category);
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateCategory(String id, Category newCategory) async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/categories/';

    final index = _categories.indexWhere((element) => element.id == id);
    if (index == -1) return;

    try {
      await http.patch(
        url + '$id.json',
        body: json.encode({
          'title': newCategory.title,
          'imageUrl': newCategory.imageUrl,
        }),
      );

      _categories[index] = newCategory;
      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> deleteCategory(String id) async {
    final url =
        'https://the-coffee-house-212b6-default-rtdb.firebaseio.com/categories/';
    final index = _categories.indexWhere((category) => category.id == id);
    Category tempCategory = _categories[index];

    try {
      var response = await http.delete(url + '$id.json');
      _categories.removeAt(index);
      notifyListeners();

      if (response.statusCode >= 400) {
        _categories.insert(index, tempCategory);
        notifyListeners();
        throw HttpException('Cannot delete product');
      }
    } catch (error) {
      throw error;
    } finally {
      tempCategory = null;
    }
  }

  Future<int> getNumberOfProductsByCategoryId(
      BuildContext context, String categoryId) async {
    if (Provider.of<Products>(context, listen: false).products.isEmpty)
      await Provider.of<Products>(context, listen: false).fetchProducts();
    return Provider.of<Products>(context, listen: false)
        .products
        .where((product) => product.categoryId == categoryId)
        .toList()
        .length;
  }
}
