import 'package:flutter/material.dart';

class InvoiceHeader extends StatelessWidget {
  const InvoiceHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          height: 70,
          width: 100,
          color: Colors.grey[300],
          alignment: Alignment.center,
          child: const Text("Company Logo"),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text("Invoice: #123456", style: TextStyle(fontSize: 14)),
            Text("Date: 2024-07-28", style: TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }
}
