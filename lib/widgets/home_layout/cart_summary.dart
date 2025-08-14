import 'package:flutter/material.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: const [
        _SummaryRow(label: "Number of items:", value: "0.00"),
        _SummaryRow(label: "Amount:", value: "0.00"),
        _SummaryRow(label: "Discount:", value: "- 0.00", valueColor: Colors.red),
        _SummaryRow(label: "Total:", value: "0.00", isBold: true),
        _SummaryRow(label: "Balance:", value: "0.00", isBold: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    Key? key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: valueColor ?? Colors.black,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: style),
        ],
      ),
    );
  }
}
