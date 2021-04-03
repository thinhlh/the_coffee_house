import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/providers/products.dart';
import 'package:the_coffee_house/services/fire_store.dart';

import 'fire_store.dart';

class FireStoreProducts extends FireStoreApi {
  Stream<Products> get products {
    return super.firestore.collection('products').snapshots().map(
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
  }

  Future<Product> addProduct(Product product) async {
    try {
      final response = await super.firestore.collection('products').add({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'categoryId': product.categoryId,
      });
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

  Future<void> updateProduct(String id, Product newProduct) async {
    try {
      await super.firestore.collection('products').doc(id).update({
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

  Future<void> deleteProduct(String productId) async {
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