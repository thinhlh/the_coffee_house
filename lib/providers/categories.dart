import 'package:flutter/material.dart';
import 'package:the_coffee_house/models/http_exception.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/services/firestore_categories.dart';
import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  Categories.fromList(this._categories);

  Future<void> fetchCategories() {
    return FireStoreCategories()
        .firestore
        .collection('categories')
        .get()
        .then((value) => this._categories = value.docs.map((e) {
              Map<String, dynamic> json = e.data();
              json['id'] = e.id;
              return Category.fromJson(json);
            }).toList());
  }

  List<String> categoryIdList() =>
      _categories.map((category) => category.id).toList();

  Category getCategoryById(String id) {
    if (id == null) return null;
    return _categories.firstWhere((element) => element.id == id);
  }

  Future<void> addCategory(Category category) async {
    try {
      final addedCategory = await FireStoreCategories().add(category);
      _categories.add(addedCategory);

      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateCategory(String id, Category newCategory) async {
    final index = _categories.indexWhere((element) => element.id == id);
    if (index == -1) return;

    try {
      await FireStoreCategories().update(newCategory);

      _categories[index] = newCategory;

      notifyListeners();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> deleteCategory(String id) async {
    final index = _categories.indexWhere((category) => category.id == id);
    if (index < 0) return;
    Category tempCategory = _categories[index];

    try {
      _categories.removeAt(index);
      await FireStoreCategories().delete(id);
    } catch (error) {
      _categories.insert(index, tempCategory);
      throw HttpException('Cannot delete product');
    } finally {
      notifyListeners();
      tempCategory = null;
    }
  }

  int getNumberOfProductsByCategoryId(
      Products productProvider, String categoryId) {
    return productProvider.products
        .where((product) => product.categoryId == categoryId)
        .toList()
        .length;
  }
}
