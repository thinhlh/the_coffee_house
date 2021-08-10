import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the/tdd/common/domain/entities/custom_user.dart';
import 'package:the/tdd/common/domain/entities/membership.dart';

// ignore: must_be_immutable
class CustomUserModel extends CustomUser {
  CustomUserModel(
    String uid,
    String name,
    String email,
    DateTime birthday,
  ) : super(
          uid: uid,
          name: name,
          email: email,
          birthday: birthday,
        );

  CustomUserModel.fromMap(Map<String, dynamic> json) {
    this.uid = json['uid'];
    this.name = json['name'];
    this.email = json['email'];
    this.birthday = json['birthday'] == null
        ? DateTime.now()
        : (json['birthday'] as Timestamp).toDate();
    this.point = json['point'] ?? 0;
    this.membership = parseMembershipFromString(json['membership']);
    this.isAdmin = json['admin'] ?? false;
    this.favoriteProducts = json['favoriteProducts'] == null
        ? []
        : (json['favoriteProducts'] as List<dynamic>).cast<String>();
    this.subscribeToNotifications = json['subscribeToNotifications'] ?? true;
    this.totalOrders = json['totalOrders'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'email': this.email,
      'birthday': this.birthday,
      'point': this.point,
      'membership': this.membership,
      'favoriteProducts': this.favoriteProducts,
      'admin': this.isAdmin,
    };
  }
}

extension ParseMembershipToString on Membership {
  String valueString() {
    if (this == Membership.Bronze) {
      return 'Bronze';
    } else if (this == Membership.Silver) {
      return 'Silver';
    } else if (this == Membership.Gold) {
      return 'Gold';
    } else {
      return 'Diamond';
    }
  }
}

Membership parseMembershipFromString(String value) {
  if (value == 'Bronze') {
    return Membership.Bronze;
  } else if (value == 'Silver') {
    return Membership.Silver;
  } else if (value == 'Gold') {
    return Membership.Gold;
  } else {
    return Membership.Diamond;
  }
}
