import 'package:the_coffee_house/models/category.dart';
import 'package:the_coffee_house/providers/categories.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class FireStoreCategories extends FireStoreApi {
  @override
  Stream<Categories> get stream => super
      .firestore
      .collection('categories')
      .snapshots()
      .map((querySnapshots) =>
          Categories.fromList(querySnapshots.docs.map((documentSnapshot) {
            Map<String, dynamic> json = documentSnapshot.data();
            json['id'] = documentSnapshot.id;
            return Category.fromJson(json);
          }).toList()));

  @override
  Future<Category> add(category) async {
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

  @override
  Future<void> update(newCategory) async {
    try {
      await super
          .firestore
          .collection('categories')
          .doc(newCategory.id)
          .update({
        'title': newCategory.title,
        'imageUrl': newCategory.imageUrl,
      });
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await super.firestore.collection('categories').doc(id).delete();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }
}
