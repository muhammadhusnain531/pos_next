import 'package:flutter/material.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({super.key});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Title
              const Text(
                "Customer Details",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              const Text(
                "All fields are required.",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              /// Main 3-column layout
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Personal Information
                    Expanded(
                      child: _buildSection(
                        "Personal Information",
                        children: [
                          _buildTextField("Customer ID",
                              hint: "CUST:8807", helper: "Auto-generated customer identifier."),
                          _buildTextField("Full Name", hint: "Enter customer's full name"),
                          _buildTextField("CNIC / Passport No.",
                              hint: "e.g., 42201-1234567-8"),
                          _buildTextField("Email Address",
                              hint: "e.g., name@example.com"),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    /// Contact & Location
                    Expanded(
                      child: _buildSection(
                        "Contact & Location",
                        children: [
                          _buildTextField("Primary Contact",
                              hint: "e.g., +92 300 1234567"),
                          _buildTextField("Mailing Address",
                              hint: "Enter street address, apartment, etc.",
                              maxLines: 3),
                          _buildTextField("City", hint: "e.g., Karachi"),
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration("Country"),
                            items: const [
                              DropdownMenuItem(
                                value: "Pakistan",
                                child: Text("Pakistan"),
                              ),
                              DropdownMenuItem(
                                value: "USA",
                                child: Text("USA"),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 24),

                    /// Account Details
                    Expanded(
                      child: _buildSection(
                        "Account Details",
                        children: [
                          _buildTextField("Associated Shop/Branch",
                              hint: "e.g., Main Branch"),
                          DropdownButtonFormField<String>(
                            decoration: _inputDecoration("Customer Type"),
                            items: const [
                              DropdownMenuItem(
                                value: "Regular",
                                child: Text("Regular"),
                              ),
                              DropdownMenuItem(
                                value: "Premium",
                                child: Text("Premium"),
                              ),
                            ],
                            onChanged: (value) {},
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Checkbox(value: true, onChanged: (val) {}),
                              const Text("Active"),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 40),
                            child: Text(
                              "Uncheck to deactivate the customer's account.",
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 16),

              /// Bottom Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.close),
                    label: const Text("Cancel"),
                    style: OutlinedButton.styleFrom(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.save),
                    label: const Text("Save Changes"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A4DFF),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  /// Section Builder
  Widget _buildSection(String title, {required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        ...children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: child,
        )),
      ],
    );
  }

  /// TextField builder
  Widget _buildTextField(String label,
      {String? hint, String? helper, int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: _inputDecoration(label).copyWith(
        hintText: hint,
        helperText: helper,
      ),
    );
  }

  static InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    );
  }
}
