import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberofitems = 0;
  int get numberofitems => _numberofitems;
  display(int no) {
    _numberofitems = no;
    notifyListeners();
  }
}
