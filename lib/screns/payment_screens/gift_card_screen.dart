import 'package:flutter/material.dart';

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({Key? key}) : super(key: key);

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  final TextEditingController _giftCardCodeController = TextEditingController();

  void _redeemGiftCard() {
    final code = _giftCardCodeController.text.trim();

    // TODO: Call payment_provider.redeemGiftCard(code)
    // TODO: Call receipt_service.printReceipt()

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gift card $code redeemed")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gift Card Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Enter gift card code", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _giftCardCodeController,
              decoration: const InputDecoration(
                labelText: "Gift Card Code",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _redeemGiftCard,
              child: const Text("Redeem Gift Card"),
            ),
          ],
        ),
      ),
    );
  }
}
