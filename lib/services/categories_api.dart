import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/category.dart';
import '../providers/categories.dart';
import 'fire_store.dart';

class CategoriesAPI extends BaseAPI {
  FirebaseStorage storage = FirebaseStorage.instance;

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

  Future<void> addCategory(
    Category category,
    bool isNeededUploadToStorage,
  ) async {
    // if true => only add image Url
    if (isNeededUploadToStorage) {
      File file = File(category.imageUrl);
      String id = firestore.collection('categories').doc().id;
      return storage
          .ref('images/categories/$id')
          .putFile(file)
          .then((task) async {
        category.id = id;
        category.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('categories')
            .doc(id)
            .set(category.toJson());
      });
    } else {
      return super.firestore.collection('categories').add(category.toJson());
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

  Future<void> updateCategory(Category category, bool isNeededUploadToStorage) {
    if (isNeededUploadToStorage) {
      File file = File(category.imageUrl);
      return storage
          .ref('images/categories/${category.id}')
          .child(category.id)
          .putFile(file)
          .then((task) async {
        category.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('categories')
            .doc(category.id)
            .update(category.toJson());
      });
    } else {
      return super
          .firestore
          .collection('categories')
          .doc(category.id)
          .update(category.toJson());
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await storage.ref('images/categories/$id').delete();
    } catch (error) {
      if (error is FirebaseException)
        // Then this is online image
        print(error.code + '=> This is online image');
      else
        throw error;
    } finally {
      super.firestore.collection('categories').doc(id).delete();
    }
  }
}
