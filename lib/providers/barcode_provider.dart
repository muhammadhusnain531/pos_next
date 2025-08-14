import 'package:flutter/material.dart';

class BarcodeProvider with ChangeNotifier {
  String _barcode = '';

  String get barcode => _barcode;

  void setBarcode(String value) {
    _barcode = value;
    notifyListeners();
  }

  void clearBarcode() {
    _barcode = '';
    notifyListeners();
  }
}
