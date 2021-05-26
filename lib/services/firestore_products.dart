import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';
import '../providers/products.dart';
import 'fire_store.dart';

class FireStoreProducts extends FireStoreApi {
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
      return Product(
        id: response.id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        categoryId: product.categoryId,
      );
    } catch (error) {
      //TODO handling error
      throw error;
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

  @override
  Future<void> delete(String productId) async {
    try {
      await super.firestore.collection('products').doc(productId).delete();
      // TODO Also delete favorited products of user
      super.firestore.collection('users').get().then(
            (user) => user.docs.forEach(
              (querySnapshot) => querySnapshot.reference.update({
                'favoriteProducts': FieldValue.arrayRemove([productId]),
              }),
            ),
          );
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }
}
