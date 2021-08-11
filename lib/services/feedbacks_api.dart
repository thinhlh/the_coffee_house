import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/models/feedback.dart';
import 'package:the/providers/feedbacks.dart';
import 'package:the/services/fire_store.dart';

class FeedbacksAPI {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<Feedbacks> get stream =>
      firestore.collection('feedbacks').snapshots().map(
            (collectionSnapshot) => Feedbacks.fromList(
              collectionSnapshot.docs.map((documentSnapshot) {
                Map<String, Object> json = documentSnapshot.data();
                json['id'] = documentSnapshot.id;
                return Feedback.fromJson(json);
              }).toList(),
            ),
          );
}
