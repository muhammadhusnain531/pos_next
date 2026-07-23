import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/services/auth_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  final _durationController = TextEditingController(text: '30');
  bool _isService = false;

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    final db = Provider.of<AppDatabase>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);

    if (authService.currentBranch == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No active branch selected.")),
      );
      return;
    }

    // Validation
    if (_nameController.text.isEmpty ||
        _barcodeController.text.isEmpty ||
        _priceController.text.isEmpty ||
        (!_isService && _quantityController.text.isEmpty) ||
        (_isService && _durationController.text.isEmpty)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields.")),
      );
      return;
    }

    try {
      // Check for duplicate barcode
      final existingProduct = await db.getProductByBarcode(_barcodeController.text);
      if (existingProduct != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Product/Service with this barcode already exists!"),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create new product or service
      final newProduct = ProductsCompanion(
        branchId: drift.Value(authService.currentBranch!.id),
        name: drift.Value(_nameController.text),
        barcode: drift.Value(_barcodeController.text),
        price: drift.Value(double.tryParse(_priceController.text) ?? 0.0),
        quantity: drift.Value(_isService ? 0 : (int.tryParse(_quantityController.text) ?? 0)),
        isService: drift.Value(_isService),
        durationMinutes: drift.Value(_isService ? (int.tryParse(_durationController.text) ?? 30) : null),
      );

      await db.addProduct(newProduct);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isService ? "Service Saved Successfully!" : "Product Saved Successfully!"),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form
      _nameController.clear();
      _barcodeController.clear();
      _priceController.clear();
      _quantityController.clear();
      _durationController.text = '30';
      _descriptionController.clear();
    } catch (e, stackTrace) {
      debugPrint("Error saving item: $e");
      debugPrint(stackTrace.toString());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error saving item: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(_isService ? "Add Service" : "Add Product"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Container(
          width: 900,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  _isService ? "Add Service in System" : "Add Product in System",
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // LEFT: Single Form
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          // Type Selection
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ChoiceChip(
                                label: const Text("Product (Retail)"),
                                selected: !_isService,
                                onSelected: (val) {
                                  if (val) setState(() => _isService = false);
                                },
                              ),
                              const SizedBox(width: 16),
                              ChoiceChip(
                                label: const Text("Service (Appointment)"),
                                selected: _isService,
                                onSelected: (val) {
                                  if (val) setState(() => _isService = true);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          _buildTextField("Barcode", _barcodeController),
                          _buildTextField(_isService ? "Service Name" : "Product Name", _nameController),
                          _buildTextField(
                            _isService ? "Service Description" : "Product Description",
                            _descriptionController,
                            maxLines: 3,
                          ),
                          if (!_isService)
                            _buildTextField(
                              "Quantity",
                              _quantityController,
                              keyboardType: TextInputType.number,
                            ),
                          if (_isService)
                            _buildTextField(
                              "Duration (minutes)",
                              _durationController,
                              keyboardType: TextInputType.number,
                            ),
                          _buildTextField(
                            "Price",
                            _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5A4DFF),
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                              ),
                              onPressed: _saveProduct,
                              child: Text(
                                _isService ? "Save Service" : "Save Product",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    const VerticalDivider(width: 40),
                    // RIGHT: Bulk Upload
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add in Bulk",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 120,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Bulk upload not yet implemented.",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller, {
        int maxLines = 1,
        TextInputType? keyboardType,
      }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}