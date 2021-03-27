import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_coffee_house/models/product.dart';
import 'package:the_coffee_house/services/fire_store.dart';

class FireStoreProducts extends FireStoreApi {
  Future<List<Product>> fetchProducts() async {
    try {
      final result = await super.firestore.collection('products').get();

      final List<DocumentSnapshot> documentSnapshots = result.docs;

      List<Product> products = [];

      documentSnapshots.forEach(
        (document) {
          final data = document.data();
          products.add(
            Product(
              id: document.id,
              title: data['title'],
              description: data['description'],
              price: data['price'],
              imageUrl: data['imageUrl'],
              categoryId: data['categoryId'],
            ),
          );
        },
      );
      return products;
    } catch (error) {
      //TODO handling error
      throw error;
    }
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

  Future<void> deleteProduct(String id) async {
    try {
      await super.firestore.collection('products').doc(id).delete();
    } catch (error) {
      //TODO handling error
      throw error;
    }
  }
}
