import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  Color _currentColor = Colors.black;
  int index = 0;
  final List<Color> _colors = [
    Colors.black,
    Colors.purpleAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.lightBlueAccent,
    Colors.cyan,
    Colors.redAccent,
    Colors.indigo,
    Colors.teal,
    Colors.deepOrange
  ];
  Color get currentColor => _currentColor;

  void generateRandomGradient() {
    index++;
    if (index >= _colors.length) index = 0;
    _currentColor = _colors[index];
    notifyListeners();
  }
}
