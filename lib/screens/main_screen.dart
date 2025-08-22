import 'package:flutter/material.dart';

class MainSaleScreen extends StatelessWidget {
  const MainSaleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            /// LEFT SECTION - Company, Cart, Summary
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Company Logo + Invoice
                    Row(
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
                            Text("Invoice: #123456",
                                style: TextStyle(fontSize: 14)),
                            Text("Date: 2024-07-28",
                                style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    const Divider(),

                    /// Cart Table Header
                    Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(vertical: 6),
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

                    /// Empty Cart Placeholder
                    const Expanded(
                      child: Center(
                        child: Text("Your cart is empty",
                            style: TextStyle(color: Colors.grey)),
                      ),
                    ),

                    const Divider(),

                    /// Summary
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        SummaryRow(label: "Number of items:", value: "0.00"),
                        SummaryRow(label: "Amount:", value: "0.00"),
                        SummaryRow(
                            label: "Discount:",
                            value: "- 0.00",
                            valueColor: Colors.red),
                        SummaryRow(
                          label: "Total:",
                          value: "0.00",
                          isBold: true,
                        ),
                        SummaryRow(
                          label: "Balance:",
                          value: "0.00",
                          isBold: true,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(width: 12),

            /// RIGHT SECTION - Action Buttons
            Expanded(
              flex: 1,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    PosButton(label: "Pay Cash", color: Colors.blue),
                    PosButton(label: "Pay Card", color: Colors.blue[700]!),
                    PosButton(label: "Gift Card", color: Colors.green),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget for Summary Row
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget for POS Buttons
class PosButton extends StatelessWidget {
  final String label;
  final Color color;

  const PosButton({super.key, required this.label, required this.color});

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
      onPressed: () {},
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
