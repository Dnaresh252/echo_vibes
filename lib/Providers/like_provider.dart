import 'package:flutter/material.dart';

class LikeProvider with ChangeNotifier {
  List<bool> _isLiked = [];
  bool isDobuleTapped = false;
  void genreateLike(int totalItems) {
    _isLiked = List.generate(totalItems, (_) => false);
  }

  bool isLiked(int index) {
    return _isLiked[index];
  }

  void toggle(int index) {
    _isLiked[index] = !_isLiked[index];
    notifyListeners();
  }

  void makeLiked(int index) {
    isDobuleTapped = true;
    _isLiked[index] = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 1), () {
      isDobuleTapped = false;
      notifyListeners();
    });
  }
}
