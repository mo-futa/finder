import 'dart:math';

import 'package:flutter/material.dart';

const Color mainColor = Color.fromRGBO(194, 54, 22, 0.8);
const Color backGColor = Color.fromRGBO(255, 245, 242, 1);


double calculateDistance(lat1, lon1, lat2, lon2){
var p = 0.017453292519943295;
var c = cos;
var a = 0.5 - c((lat2 - lat1) * p)/2 +
c(lat1 * p) * c(lat2 * p) *
(1 - c((lon2 - lon1) * p))/2;
return 12742 * asin(sqrt(a));
}

double totalDistance = calculateDistance(26.196435, 78.197535,26.197195, 78.196408);


