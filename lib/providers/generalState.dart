// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';

class GeneralState with ChangeNotifier {
  MiniSPot? _miniSPot;

  void setIt({required String id, required double lat, required double lng}) {
    _miniSPot = MiniSPot(id: id, lat: lat, lng: lng);
    notifyListeners();
  }

  MiniSPot? get getIt => _miniSPot;
}

class MiniSPot {
  String id;
  double lat;
  double lng;
  MiniSPot({required this.id, required this.lat, required this.lng});
}
