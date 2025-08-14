import 'package:flutter/material.dart';

class ActionButtonsGrid extends StatelessWidget {
  const ActionButtonsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Same labels & colors as your original design
    final items = <_ActionItem>[
      _ActionItem("Pay Cash", Colors.blue),
      _ActionItem("Pay Card", Colors.blue), // (was blue[700], simplified to const)
      _ActionItem("Gift Card", Colors.green),
      _ActionItem("Discount", Colors.orange),
      _ActionItem("Stock Details", Colors.grey),
      _ActionItem("Day/Opening Closing", Colors.grey),
      _ActionItem("Return", Colors.red),
      _ActionItem("Home Delay", Colors.black87),
      _ActionItem("Issue Gift Card", Colors.green),
      _ActionItem("Void Product", Colors.red),
      _ActionItem("Void Payment", Colors.red),
      _ActionItem("Clean Screen", Colors.purple),
      _ActionItem("Customer Details", Colors.indigo),
      _ActionItem("Reports", Colors.black87),
    ];

    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      childAspectRatio: 1.5,
      children: items
          .map((i) => _PosButton(label: i.label, color: i.color, onTap: () {}))
          .toList(),
    );
  }
}

class _ActionItem {
  final String label;
  final Color color;
  const _ActionItem(this.label, this.color);
}

class _PosButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _PosButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
      ),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
