import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:the/models/membership.dart';
import 'package:the/models/promotion.dart';
import 'package:the/providers/promotions.dart';
import 'package:the/services/fire_store.dart';

class PromotionsAPI extends BaseAPI {
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Future<void> add(promotion) async {
    try {
      await super.firestore.collection('promotions').add(promotion.toJson());
    } catch (error) {
      throw error;
    }
  }

  Future<void> addPromotion(
    Promotion promotion,
    bool isNeededUploadToStorage,
  ) async {
    // if true => only add image Url
    if (isNeededUploadToStorage) {
      File file = File(promotion.imageUrl);
      String id = firestore.collection('promotions').doc().id;
      return storage
          .ref('images/promotions/$id')
          .putFile(file)
          .then((task) async {
        promotion.id = id;
        promotion.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('promotions')
            .doc(id)
            .set(promotion.toJson());
      });
    } else {
      return super.firestore.collection('promotions').add(promotion.toJson());
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await storage.ref('images/promotions/$id').delete();
    } catch (error) {
      if (error is FirebaseException) {
        //(error as FirebaseException).code=='object-not-found' // Then dont delete at storage
      } else {
        throw error;
      }
    } finally {
      super.firestore.collection('promotions').doc(id).delete();
    }
  }

  @override
  Stream<Promotions> get stream =>
      super.firestore.collection('promotions').snapshots().map(
            (querySnapshot) => Promotions.fromList(
              querySnapshot.docs.map((queryDocumentSnapshot) {
                Map<String, dynamic> json = queryDocumentSnapshot.data();
                json['id'] = queryDocumentSnapshot.id;
                return Promotion.fromJson(json);
              }).toList(),
            ),
          );

  Stream<Promotions> getUserPrmotionStream(Membership membership) => super
      .firestore
      .collection('promotions')
      .where('targetCustomer', arrayContains: membership.valueString())
      .snapshots()
      .map(
        (querySnapshot) => Promotions.fromList(
          querySnapshot.docs.map((queryDocumentSnapshot) {
            Map<String, dynamic> json = queryDocumentSnapshot.data();
            json['id'] = queryDocumentSnapshot.id;
            return Promotion.fromJson(json);
          }).toList(),
        ),
      );

  @override
  Future<void> update(promotion) async {
    try {
      await super
          .firestore
          .collection('promotions')
          .doc(promotion.id)
          .update((promotion as Promotion).toJson());
    } catch (error) {
      throw error;
    }
  }

  Future<void> updatePromotion(
      Promotion promotion, bool isNeededUploadToStorage) {
    if (isNeededUploadToStorage) {
      File file = File(promotion.imageUrl);
      return storage
          .ref('images/promotions/${promotion.id}')
          .putFile(file)
          .then((task) async {
        promotion.imageUrl = await task.ref.getDownloadURL();
        return super
            .firestore
            .collection('promotions')
            .doc(promotion.id)
            .update(promotion.toJson());
      });
    } else {
      return super
          .firestore
          .collection('promotions')
          .doc(promotion.id)
          .update(promotion.toJson());
    }
  }
}
