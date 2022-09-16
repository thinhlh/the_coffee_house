import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../models/product.dart';
import '../providers/products.dart';
import 'fire_store.dart';

class ProductsAPI extends BaseAPI {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Stream<Products> get stream =>
      super.firestore.collection('products').snapshots().map(
            (querySnapshot) => Products.fromList(
              querySnapshot.docs.map(
                (queryDocumentSnapshot) {
                  Map<String, dynamic> json = queryDocumentSnapshot.data();
                  json['id'] = queryDocumentSnapshot.id;
                  return Product.fromJson(json);
                },
              ).toList(),
            ),
          );

  @override
  Future<Product> add(product) async {
    try {
      final response =
          await super.firestore.collection('products').add(product.toJson());
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> addProduct(Product product, bool isNeededUploadToStorage) async {
    // if true => only add image Url
    if (isNeededUploadToStorage) {
      File file = File(product.imageUrl);
      String id = firestore.collection('products').doc().id;
      return storage
          .ref('images/products/$id')
          .putFile(file)
          .then((task) async {
        product.id = id;
        product.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('products')
            .doc(id)
            .set(product.toJson());
      });
    } else {
      return super.firestore.collection('products').add(product.toJson());
    }
  }

  @override
  Future<void> update(newProduct) async {
    try {
      await super.firestore.collection('products').doc(newProduct.id).update({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,
        'categoryId': newProduct.categoryId,
      });
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }

  Future<void> updateProduct(
    Product product,
    bool isNeededUploadToStorage,
  ) {
    if (isNeededUploadToStorage) {
      File file = File(product.imageUrl);
      return storage
          .ref('images/products/${product.id}')
          .putFile(file)
          .then((task) async {
        product.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('products')
            .doc(product.id)
            .update(product.toJson());
      });
    } else {
      return super
          .firestore
          .collection('products')
          .doc(product.id)
          .update(product.toJson());
    }
  }

  @override
  Future<void> delete(String productId) async {
    try {
      await storage.ref('images/products/' + productId).delete();
    } catch (error) {
      if (error is FirebaseException) {
        //(error as FirebaseException).code=='object-not-found' // Then dont delete at storage
      } else {
        throw error;
      }
    } finally {
      super.firestore.collection('products').doc(productId).delete();
    }
  }
}
