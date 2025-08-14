import 'package:flutter/material.dart';

class CartTable extends StatelessWidget {
  const CartTable({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header row (matches your labels)
          Container(
            color: Colors.grey[100],
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: const Row(
              children: [
                Expanded(flex: 2, child: Text("Barcode")),
                Expanded(flex: 4, child: Text("Description")),
                Expanded(child: Text("Price")),
                Expanded(child: Text("Tax")),
                Expanded(child: Text("Qty")),
                Expanded(child: Text("Amount")),
              ],
            ),
          ),
          const Divider(height: 1),

          // Body (empty placeholder for now)
          const Expanded(
            child: Center(
              child: Text(
                "Your cart is empty",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
