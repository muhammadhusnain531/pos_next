import 'package:flutter/material.dart';
import '../models/product.dart';

/*class ProductProvider with ChangeNotifier {
  final List<Product> _products = [
    Product(id: 1, name: "Coca Cola", barcode: "123456", price: 2.0),
    Product(id: 2, name: "Pepsi", barcode: "987654", price: 1.8),
    // Add your test products here
  ];

  List<Product> get products => _products;

  Product? findByBarcodeOrName(String query) {
    try {
      return _products.firstWhere(
            (p) =>
        p.barcode.toLowerCase() == query.toLowerCase() ||
            p.name.toLowerCase() == query.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }
}*/
