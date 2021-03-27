import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/category.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class FireStoreCategories extends FireStoreApi {
  Future<List<Category>> fetchCategories() async {
    try {
      final result = await super.firestore.collection('categories').get();

      final List<DocumentSnapshot> documentSnapshots = result.docs;

      List<Category> categories = [];
      documentSnapshots.forEach(
        (document) {
          final data = document.data();
          categories.add(
            Category(
              id: document.id,
              title: data['title'],
              imageUrl: data['imageUrl'],
            ),
          );
        },
      );
      return categories;
    } catch (error) {
      // TODO handling error
      throw error;
    }
  }

  Future<Category> addCategory(Category category) async {
    try {
      final response = await super.firestore.collection('categories').add({
        'title': category.title,
        'imageUrl': category.imageUrl,
      });

      return Category(
        id: response.id,
        title: category.title,
        imageUrl: category.imageUrl,
      );
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateCategory(String id, Category newCategory) async {
    try {
      await super.firestore.collection('categories').doc(id).update({
        'title': newCategory.title,
        'imageUrl': newCategory.imageUrl,
      });
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> deleteCategory(String id) async {
    try {
      await super.firestore.collection('categories').doc(id).delete();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }
}
