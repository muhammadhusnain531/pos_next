import 'package:flutter/material.dart';

class GiftCardScreen extends StatelessWidget {
  const GiftCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 1100,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Left Form Section
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Issue Gift Card",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Row 1
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Customer ID", "Enter customer ID")),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("Name", "Enter full name")),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Row 2
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Contact", "Enter contact number")),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("CNIC", "Enter CNIC number")),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Row 3
                      Row(
                        children: [
                          Expanded(child: _buildTextField("City", "Enter city")),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("Country", "Enter country")),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Address
                      _buildTextField("Address", "Enter full address", maxLines: 3),
                      const SizedBox(height: 16),

                      /// Issue Date & Expiry Date
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField("Issue Date"),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateField("Expiry Date"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Amount
                      TextField(
                        decoration: InputDecoration(
                          labelText: "Amount",
                          prefixText: "\$ ",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      /// Payment Options
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.money),
                              label: const Text("Cash"),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.credit_card),
                              label: const Text("Card"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A4DFF),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      /// Issue Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A4DFF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                          ),
                          child: const Text("Issue Card"),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 32),

              /// Right Reports Section
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFFF9FAFB),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Old Report",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildReportCard("#12345", "2023-10-26"),
                      const SizedBox(height: 12),
                      _buildReportCard("#12344", "2023-10-25"),
                      const SizedBox(height: 12),
                      _buildReportCard("#12343", "2023-10-24"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper: TextField
  static Widget _buildTextField(String label, String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  /// Helper: DateField (no logic, just UI)
  static Widget _buildDateField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: "mm/dd/yyyy",
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  /// Helper: Report Card
  static Widget _buildReportCard(String id, String date) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Report $id",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Date: $date", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {},
            child: const Text(
              "View Details",
              style: TextStyle(color: Color(0xFF5A4DFF)),
            ),
          ),
        ],
      ),
    );
  }
}
