import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // You might need to add intl to pubspec, but for now I'll use basic formatting or assume it's there. If not, I'll use manual formatting.

class GiftCardScreen extends StatefulWidget {
  const GiftCardScreen({super.key});

  @override
  State<GiftCardScreen> createState() => _GiftCardScreenState();
}

class _GiftCardScreenState extends State<GiftCardScreen> {
  // Controllers
  final TextEditingController _customerIdController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _cnicController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _issueDateController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  // State
  String _paymentMethod = "Cash"; // Default to Cash
  List<Map<String, String>> _reports = [
    {"id": "#12345", "date": "2023-10-26"},
    {"id": "#12344", "date": "2023-10-25"},
    {"id": "#12343", "date": "2023-10-24"},
  ];

  @override
  void dispose() {
    _customerIdController.dispose();
    _nameController.dispose();
    _contactController.dispose();
    _cnicController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _addressController.dispose();
    _amountController.dispose();
    _issueDateController.dispose();
    _expiryDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        // Simple formatting YYYY-MM-DD
        String formattedDate = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
        controller.text = formattedDate;
      });
    }
  }

  void _handleIssueCard() {
    // Basic Validation
    if (_nameController.text.isEmpty ||
        _amountController.text.isEmpty ||
        _issueDateController.text.isEmpty ||
        _expiryDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all required fields (Name, Amount, Dates)"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Simulate Issuing
    final newReportId = "#${12346 + _reports.length}";
    final newReportDate = _issueDateController.text;

    setState(() {
      _reports.insert(0, {"id": newReportId, "date": newReportDate});
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Success"),
        content: Text("Gift Card Issued Successfully!\nID: $newReportId\nAmount: \$${_amountController.text}\nPayment: $_paymentMethod"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _clearForm();
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _clearForm() {
    _customerIdController.clear();
    _nameController.clear();
    _contactController.clear();
    _cnicController.clear();
    _cityController.clear();
    _countryController.clear();
    _addressController.clear();
    _amountController.clear();
    _issueDateController.clear();
    _expiryDateController.clear();
    setState(() {
      _paymentMethod = "Cash";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Gift Card"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: 1100,
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(24),
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
                          Expanded(child: _buildTextField("Customer ID", "Enter customer ID", controller: _customerIdController)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("Name", "Enter full name", controller: _nameController)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Row 2
                      Row(
                        children: [
                          Expanded(child: _buildTextField("Contact", "Enter contact number", controller: _contactController, keyboardType: TextInputType.phone)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("CNIC", "Enter CNIC number", controller: _cnicController, keyboardType: TextInputType.number)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Row 3
                      Row(
                        children: [
                          Expanded(child: _buildTextField("City", "Enter city", controller: _cityController)),
                          const SizedBox(width: 16),
                          Expanded(child: _buildTextField("Country", "Enter country", controller: _countryController)),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Address
                      _buildTextField("Address", "Enter full address", maxLines: 3, controller: _addressController),
                      const SizedBox(height: 16),

                      /// Issue Date & Expiry Date
                      Row(
                        children: [
                          Expanded(
                            child: _buildDateField("Issue Date", _issueDateController),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildDateField("Expiry Date", _expiryDateController),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      /// Amount
                      TextField(
                        controller: _amountController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                            child: _PaymentTypeButton(
                              label: "Cash",
                              icon: Icons.money,
                              isSelected: _paymentMethod == "Cash",
                              onTap: () => setState(() => _paymentMethod = "Cash"),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _PaymentTypeButton(
                              label: "Card",
                              icon: Icons.credit_card,
                              isSelected: _paymentMethod == "Card",
                              onTap: () => setState(() => _paymentMethod = "Card"),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      /// Issue Button
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: _handleIssueCard,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5A4DFF),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 16),
                          ),
                          child: const Text("Issue Card", style: TextStyle(color: Colors.white)),
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
                        "Recent Issues",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView.separated(
                          itemCount: _reports.length,
                          separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                          itemBuilder: (ctx, index) {
                            final report = _reports[index];
                            return _buildReportCard(report["id"]!, report["date"]!);
                          },
                        ),
                      ),
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

  Widget _buildTextField(String label, String hint, {int maxLines = 1, TextEditingController? controller, TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
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

  Widget _buildDateField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      onTap: () => _selectDate(context, controller),
      decoration: InputDecoration(
        labelText: label,
        hintText: "YYYY-MM-DD",
        suffixIcon: const Icon(Icons.calendar_today, size: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildReportCard(String id, String date) {
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
          Text("Gift Card $id",
              style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text("Date: $date", style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 8),
          InkWell(
            onTap: () {
               // View Details logic
            },
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

class _PaymentTypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentTypeButton({
    Key? key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
      label: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black54)),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? const Color(0xFF5A4DFF) : Colors.grey[200],
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: isSelected ? 2 : 0,
        side: isSelected ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
      ),
    );
  }
}
