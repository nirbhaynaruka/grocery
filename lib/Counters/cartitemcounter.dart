import 'package:flutter/foundation.dart';
import 'package:grocery/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter = EcommerceApp.sharedPreferences
          .getStringList(EcommerceApp.userCartList)
          .length -
      1;
  int get count => _counter;
  Future<void> displayResult() async {
    int _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .length -
        1;
    print(_counter);
    await Future.delayed(const Duration(milliseconds: 100), () {
      notifyListeners();
    });
  }
}
