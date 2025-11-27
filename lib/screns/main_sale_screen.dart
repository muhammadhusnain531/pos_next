import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../services/database_service.dart';
import '../services/auth_service.dart';
import 'business_screens/day_opening_screen.dart';
import 'business_screens/day_closing_screen.dart';

class MainSaleScreen extends StatefulWidget {
  const MainSaleScreen({super.key});

  @override
  State<MainSaleScreen> createState() => _MainSaleScreenState();
}

class _MainSaleScreenState extends State<MainSaleScreen> {
  final TextEditingController _barcodeController = TextEditingController();
  final List<CartItem> _cart = [];
  double _discount = 0.0;
  bool _isLoading = false;

  double get _subtotal => _cart.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
  double get _total => (_subtotal - _discount).clamp(0.0, double.infinity);

  @override
  void dispose() {
    _barcodeController.dispose();
    super.dispose();
  }

  Future<void> _searchAndAddProduct(String query) async {
    if (query.isEmpty) return;

    final db = Provider.of<AppDatabase>(context, listen: false);
    final products = await db.searchProducts(query);

    if (products.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product not found!'), backgroundColor: Colors.red),
        );
      }
      return;
    }

    // If multiple found, maybe show dialog (simplified: take first)
    final product = products.first;
    _addToCart(product);
    _barcodeController.clear();
  }

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index != -1) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product, quantity: 1));
      }
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
    });
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      _cart[index].quantity += delta;
      if (_cart[index].quantity <= 0) {
        _cart.removeAt(index);
      }
    });
  }

  Future<void> _processPayment(String method) async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cart is empty!')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);

      if (auth.currentBranch == null) {
        throw Exception("No active branch. Please login again.");
      }

      final sale = SalesCompanion(
        branchId: drift.Value(auth.currentBranch!.id),
        userId: drift.Value(auth.currentUser?.id),
        invoiceNumber: drift.Value("INV-${DateTime.now().millisecondsSinceEpoch}"),
        totalAmount: drift.Value(_total),
        discount: drift.Value(_discount),
        paymentMethod: drift.Value(method),
        date: drift.Value(DateTime.now()),
      );

      final saleItems = _cart.map((item) {
        return SaleItemsCompanion(
          productId: drift.Value(item.product.id),
          quantity: drift.Value(item.quantity),
          price: drift.Value(item.product.price),
          saleId: const drift.Value.absent(), // Will be set by transaction
        );
      }).toList();

      await db.createSale(sale, saleItems);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment Successful ($method)!'), backgroundColor: Colors.green),
        );
        setState(() {
          _cart.clear();
          _discount = 0.0;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text("POS - ${auth.currentBranch?.name ?? 'Unknown Branch'}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => auth.logout(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            /// LEFT SECTION - Cart & Search
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
                    // Search Bar
                    TextField(
                      controller: _barcodeController,
                      decoration: InputDecoration(
                        hintText: "Scan Barcode or Search Product...",
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => _barcodeController.clear(),
                        ),
                      ),
                      onSubmitted: _searchAndAddProduct,
                    ),
                    const SizedBox(height: 12),
                    const Divider(),

                    // Cart Header
                    Container(
                      color: Colors.grey[100],
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: const Row(
                        children: [
                          Expanded(flex: 3, child: Text("Product", style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text("Price", style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 2, child: Text("Qty", style: TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(flex: 1, child: Text("Total", style: TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(width: 30), // For delete icon
                        ],
                      ),
                    ),

                    // Cart List
                    Expanded(
                      child: _cart.isEmpty
                          ? const Center(child: Text("Cart is empty", style: TextStyle(color: Colors.grey)))
                          : ListView.builder(
                              itemCount: _cart.length,
                              itemBuilder: (context, index) {
                                final item = _cart[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                                  decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.black12)),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 3, child: Text(item.product.name)),
                                      Expanded(flex: 1, child: Text(item.product.price.toStringAsFixed(2))),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline, size: 20),
                                              onPressed: () => _updateQuantity(index, -1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text("${item.quantity}"),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline, size: 20),
                                              onPressed: () => _updateQuantity(index, 1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          (item.product.price * item.quantity).toStringAsFixed(2),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _removeFromCart(index),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),

                    const Divider(),

                    // Summary
                    Column(
                      children: [
                        SummaryRow(label: "Subtotal:", value: _subtotal.toStringAsFixed(2)),
                        SummaryRow(label: "Discount:", value: "- ${_discount.toStringAsFixed(2)}", valueColor: Colors.red),
                        const Divider(),
                        SummaryRow(label: "Total:", value: _total.toStringAsFixed(2), isBold: true, fontSize: 20),
                      ],
                    ),
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
                child: Column(
                  children: [
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2, // 2 columns for better touch targets
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 1.5,
                        children: [
                          PosButton(
                            label: "Pay Cash",
                            color: Colors.green,
                            icon: Icons.money,
                            onPressed: () => _processPayment('Cash'),
                          ),
                          PosButton(
                            label: "Pay Card",
                            color: Colors.blue,
                            icon: Icons.credit_card,
                            onPressed: () => _processPayment('Card'),
                          ),
                          PosButton(
                            label: "Day Open/Close",
                            color: Colors.orange,
                            icon: Icons.store,
                            onPressed: () async {
                              final db = Provider.of<AppDatabase>(context, listen: false);
                              final auth = Provider.of<AuthService>(context, listen: false);
                              if (auth.currentBranch == null) return;
                              
                              final currentDay = await db.getCurrentBusinessDay(auth.currentBranch!.id);
                              if (!context.mounted) return;
                              if (currentDay == null) {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const DayOpeningScreen()));
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (_) => const DayClosingScreen()));
                              }
                            },
                          ),
                          PosButton(
                            label: "Clear Cart",
                            color: Colors.red,
                            icon: Icons.delete_sweep,
                            onPressed: () => setState(() {
                              _cart.clear();
                              _discount = 0.0;
                            }),
                          ),
                        ],
                      ),
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

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});
}

class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;
  final double fontSize;

  const SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
    this.fontSize = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontSize: fontSize, fontWeight: isBold ? FontWeight.bold : FontWeight.normal, color: valueColor)),
        ],
      ),
    );
  }
}

class PosButton extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onPressed;

  const PosButton({
    super.key,
    required this.label,
    required this.color,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32),
          const SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
