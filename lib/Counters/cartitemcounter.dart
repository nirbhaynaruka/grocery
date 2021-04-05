import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:grocery/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  static String val =
      EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList);
  static Map<String, dynamic> decodedMap = json.decode(val);
  int _counter = decodedMap.length - 1;

  int get count => _counter;
  Future<void> displayResult() async {
    String val =
        EcommerceApp.sharedPreferences.getString(EcommerceApp.userCartList);
    Map<String, dynamic> decodedMap = json.decode(val);
    int _counter = decodedMap.length - 1;
    print(_counter);
    await Future.delayed(const Duration(milliseconds: 1), () {
      notifyListeners();
    });
  }
}
