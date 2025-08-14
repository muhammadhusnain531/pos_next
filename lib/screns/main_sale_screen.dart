import 'package:flutter/material.dart';
import '../widgets/home_layout/barcode_input_section.dart';
import '../widgets/home_layout/invoice_header.dart';
import '../widgets/home_layout/cart_table.dart';
import '../widgets/home_layout/cart_summary.dart';
import '../widgets/home_layout/action_buttons_grid.dart';

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
            /// LEFT SECTION
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
                  children: const [
                    /// Invoice header
                    InvoiceHeader(),
                    SizedBox(height: 12),

                    /// Barcode / Product Search
                    BarcodeInputSection(),
                    SizedBox(height: 12),

                    /// Cart table
                    Expanded(child: CartTable()),

                    /// Summary totals
                    CartSummary(),
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
                child:  ActionButtonsGrid(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
