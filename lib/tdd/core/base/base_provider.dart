import 'package:flutter/material.dart';

abstract class BaseProvider with ChangeNotifier {
  // ignore: unused_field
  bool _loading = false;

  set loading(bool _loading) => this._loading = _loading;

  bool get loading => this._loading;

  void showLoading() {
    _loading = true;
    notifyListeners();
  }

  void dispatchLoading() {
    _loading = false;
    notifyListeners();
  }
}
