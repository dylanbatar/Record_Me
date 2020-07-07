import 'package:flutter/material.dart';

class StarredModel extends ChangeNotifier {
  List _starred = [];

  List get starred => this._starred;
  set starred(List starred) {
    this._starred = starred;
    notifyListeners();
  }

  setStarred(List starred) {
    this._starred = starred;
    notifyListeners();
  }

  addStarred(value) {
    this._starred.add(value);
    notifyListeners();
  }
}
