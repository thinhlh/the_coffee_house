import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseAPI<T> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<T> get stream;

  Future<void> add(T object);

  Future<void> update(dynamic newObject);

  Future<void> delete(String id);
}
