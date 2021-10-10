import 'package:finder_v2/models/spot.dart';
import 'package:flutter/cupertino.dart';

class CurrentPositionProvider with ChangeNotifier {
  MyPosition? _myPosition;

  void setPosition({required MyPosition myPosition}) {
    _myPosition = myPosition;
    notifyListeners();
  }

  MyPosition? get myPosition => _myPosition;
}
