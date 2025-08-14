import 'package:flutter/material.dart';
import '../barcode/barcode_input_field.dart';

class BarcodeInputSection extends StatelessWidget {
  const BarcodeInputSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Product Search / Barcode Scan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 8),
        BarcodeInputField(),
      ],
    );
  }
}
