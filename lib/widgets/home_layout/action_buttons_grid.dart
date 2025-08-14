import 'package:flutter/material.dart';
import '../../screns/payment_screens/card_payment_screen.dart';
import '../../screns/payment_screens/cash_payment_screen.dart';
import '../../screns/payment_screens/gift_card_screen.dart';

class ActionButtonsGrid extends StatelessWidget {
  const ActionButtonsGrid({Key? key}) : super(key: key);

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: [
        PosButton(
          label: "Pay Cash",
          color: Colors.blue,
          onTap: () => _openScreen(context, const CashPaymentScreen()),
        ),
        PosButton(
          label: "Pay Card",
          color: Colors.blue[700]!,
          onTap: () => _openScreen(context, const CardPaymentScreen()),
        ),
        PosButton(
          label: "Gift Card",
          color: Colors.green,
          onTap: () => _openScreen(context, const GiftCardScreen()),
        ),
        PosButton(label: "Discount", color: Colors.orange),
        PosButton(label: "Stock Details", color: Colors.grey),
        PosButton(label: "Day/Opening Closing", color: Colors.grey[700]!),
        PosButton(label: "Return", color: Colors.red[300]!),
        PosButton(label: "Home Delay", color: Colors.grey[800]!),
        PosButton(label: "Issue Gift Card", color: Colors.green[700]!),
        PosButton(label: "Void Product", color: Colors.red),
        PosButton(label: "Void Payment", color: Colors.red[800]!),
        PosButton(label: "Clean Screen", color: Colors.purple),
        PosButton(label: "Customer Details", color: Colors.indigo),
        PosButton(label: "Reports", color: Colors.black87),
      ],
    );
  }
}

class PosButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const PosButton({
    Key? key,
    required this.label,
    required this.color,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
      ),
      onPressed: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
