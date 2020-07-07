import 'package:flutter/material.dart';

class CategoriesModel extends ChangeNotifier {
  List _categories = [];

  List get categories => this._categories;
  set categories(List categories) {
    this._categories = categories;
    notifyListeners();
  }

  setCategories(List categories) {
    this._categories = categories;
    notifyListeners();
  }
}
