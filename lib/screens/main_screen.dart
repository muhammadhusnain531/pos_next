import 'package:flutter/material.dart';
import 'package:posnext/paybycashpage.dart';
import 'package:posnext/paybycardpage.dart';
import 'package:posnext/giftcardscreen.dart';
import 'package:posnext/homedeliverypage.dart';
import 'package:posnext/salereportpage.dart';
import 'package:posnext/stockdetailspage.dart';
import 'package:posnext/addproductscreen.dart';
import 'package:posnext/customerdetailsscreen.dart';

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
                    
                    const SizedBox(height: 16),
                    
                    /// Search / Barcode Input
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Enter Barcode / Product Name",
                        prefixIcon: const Icon(Icons.qr_code_scanner),
                        suffixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      onSubmitted: (value) {
                        // TODO: Implement search logic
                      },
                    ),
                    
                    const SizedBox(height: 16),

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
                    PosButton(
                      label: "Pay Cash", 
                      color: Colors.blue,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PayByCashPage())),
                    ),
                    PosButton(
                      label: "Pay Card", 
                      color: Colors.blue[700]!,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const PayByCardPage())),
                    ),
                    PosButton(
                      label: "Gift Card", 
                      color: Colors.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiftCardScreen())),
                    ),
                    PosButton(
                      label: "Discount", 
                      color: Colors.orange,
                      // TODO: Create Discount Page
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Stock Details", 
                      color: Colors.grey,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StockDetailsPage())),
                    ),
                    PosButton(
                      label: "Day/Opening Closing", 
                      color: Colors.grey[700]!,
                      // TODO: Create Day Opening/Closing Page
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Return", 
                      color: Colors.red[300]!,
                      // TODO: Create Return Page
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Home Delivery", 
                      color: Colors.grey[800]!,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeDeliveryPage())),
                    ),
                    PosButton(
                      label: "Issue Gift Card", 
                      color: Colors.green[700]!,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiftCardScreen())), // Reusing GiftCardScreen for now
                    ),
                    PosButton(
                      label: "Void Product", 
                      color: Colors.red,
                      // TODO: Create Void Product Logic/Page
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Void Payment", 
                      color: Colors.red[800]!,
                      // TODO: Create Void Payment Logic/Page
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Clean Screen", 
                      color: Colors.purple,
                      // TODO: Create Clean Screen Logic
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Customer Details", 
                      color: Colors.indigo,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerDetailsScreen())),
                    ),
                    PosButton(
                      label: "Reports", 
                      color: Colors.black87,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleReportPage())),
                    ),
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
  final VoidCallback? onTap;

  const PosButton({
    super.key, 
    required this.label, 
    required this.color,
    this.onTap,
  });

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
      onPressed: onTap ?? () {},
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
