import 'package:flutter/foundation.dart';
import 'package:the/models/feedback.dart';
import 'package:the/services/feedbacks_api.dart';

class Feedbacks with ChangeNotifier {
  List<Feedback> _feedbacks = [];

  List<Feedback> get feedbacks {
    return [..._feedbacks];
  }

  Feedbacks.fromList(this._feedbacks);

  Future<void> fetchFeedbacks() {
    return FeedbacksAPI().firestore.collection('feedbacks').get().then(
          (value) => this._feedbacks = value.docs.map((e) {
            Map<String, dynamic> json = e.data();
            json['id'] = e.id;
            return Feedback.fromJson(json);
          }).toList(),
        );
  }
}
