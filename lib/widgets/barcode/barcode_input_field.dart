import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/barcode_provider.dart';
import '../../providers/product_provider.dart';


class BarcodeInputField extends StatefulWidget {
  const BarcodeInputField({Key? key}) : super(key: key);

  @override
  State<BarcodeInputField> createState() => _BarcodeInputFieldState();
}

class _BarcodeInputFieldState extends State<BarcodeInputField> {
  final TextEditingController _controller = TextEditingController();

  void _onSubmit(String value) {
    if (value.isEmpty) return;

    // Update barcode in provider
    final barcodeProvider =
    Provider.of<BarcodeProvider>(context, listen: false);
    barcodeProvider.setBarcode(value);

    // Search product in product provider
    final productProvider =
    //Provider.of<ProductProvider>(context, listen: false);
    //productProvider.searchAndAddToCart(value);

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Scan barcode or search product...',
        prefixIcon: const Icon(Icons.qr_code_scanner),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () => _controller.clear(),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      ),
      onSubmitted: _onSubmit,
    );
  }
}

