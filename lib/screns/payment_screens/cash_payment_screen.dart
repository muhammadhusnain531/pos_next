import 'package:flutter/material.dart';

class CashPaymentScreen extends StatefulWidget {
  const CashPaymentScreen({Key? key}) : super(key: key);

  @override
  State<CashPaymentScreen> createState() => _CashPaymentScreenState();
}

class _CashPaymentScreenState extends State<CashPaymentScreen> {
  final TextEditingController _amountController = TextEditingController();

  void _processCashPayment() {
    final amount = double.tryParse(_amountController.text) ?? 0.0;

    // TODO: Call payment_provider.processCashPayment(amount)
    // TODO: Call receipt_service.printReceipt()

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Cash payment of \$${amount.toStringAsFixed(2)} processed")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cash Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Enter amount received", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _processCashPayment,
              child: const Text("Confirm Payment"),
            ),
          ],
        ),
      ),
    );
  }
}
