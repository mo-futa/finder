// ignore_for_file: file_names

import 'package:finder_v2/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CategoriesProvider with ChangeNotifier {
  final List<String> _allCategories = [
    'fillingStation',
    'diner',
    'gym',
    'mobilemoney',
    'mosque',
    'policestation',
    'repairs',
    'school',
    'shop',
    'barber',
    'church',
    'hairdressing',
    'miscelineous'
  ];
  final List<String> _selectedCategories = [];

  List<String> get allCategories => _allCategories;
  List<String> get selectedCategories => _selectedCategories;

  void addCategory(String category) {
    _selectedCategories.add(category);
    notifyListeners();
  }

  static Widget getCategoryIcon(String category) {
    switch (category) {
      case 'fillingStation':
        return Image.asset(  
          'assets/fillingstation.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'diner':
        return Image.asset(
          'assets/foodjoint.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'gym':
        return Image.asset(
          'assets/gym.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'mobilemoney':
        return Image.asset(
          'assets/mobilemoney.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'mosque':
        return Image.asset(
          'assets/mosque.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'policestation':
        return Image.asset(
          'assets/policestation.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'repairs':
        return Image.asset(
          'assets/repairs.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'school':
        return Image.asset(
          'assets/school.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'shop':
        return Image.asset(
          'assets/shop.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'barber':
        return Image.asset(
          'assets/barber.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'hairdressing':
        return Image.asset(
          'assets/hairdressing.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      case 'church':
        return Image.asset(
          'assets/church.png',
          height: 20,
          color: mainColor,
          fit: BoxFit.fitHeight,
        );
      default:
        return const Icon(
          Icons.location_city,
          color: mainColor,
        );
    }
  }

  void removeCategory(String category) {
    _selectedCategories.remove(category);
    notifyListeners();
  }
}
