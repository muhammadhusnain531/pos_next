import 'package:flutter/material.dart';

class CardPaymentScreen extends StatefulWidget {
  const CardPaymentScreen({Key? key}) : super(key: key);

  @override
  State<CardPaymentScreen> createState() => _CardPaymentScreenState();
}

class _CardPaymentScreenState extends State<CardPaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _holderNameController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  void _processCardPayment() {
    // TODO: Call payment_provider.processCardPayment(...)
    // TODO: Call receipt_service.printReceipt()

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Card payment processed")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Card Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _cardNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Card Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _holderNameController,
              decoration: const InputDecoration(
                labelText: "Card Holder Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _expiryController,
                    decoration: const InputDecoration(
                      labelText: "MM/YY",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _cvvController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "CVV",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processCardPayment,
              child: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
