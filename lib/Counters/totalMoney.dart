import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier {
  double _totalamount = 0;
  double get totalAmount => _totalamount;
  displayResult(double no) async {
    _totalamount = no;
    await Future.delayed(const Duration(milliseconds: 1), () {
      notifyListeners();
    });
  }
}
