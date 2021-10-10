// ignore_for_file: file_names

import 'package:finder_v2/models/user.dart';
import 'package:flutter/cupertino.dart';

class UserProvider with ChangeNotifier {
  User? _user; 

  void setUser(User user) => _user = user;

  User get user => _user!;
  
}
