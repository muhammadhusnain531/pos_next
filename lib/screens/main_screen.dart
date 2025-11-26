import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift; // Alias for drift columns/values
import 'package:posnext/services/database_service.dart';
import 'package:posnext/paybycashpage.dart';
import 'package:posnext/paybycardpage.dart';
import 'package:posnext/giftcardscreen.dart';
import 'package:posnext/homedeliverypage.dart';
import 'package:posnext/salereportpage.dart';
import 'package:posnext/stockdetailspage.dart';
import 'package:posnext/addproductscreen.dart';
import 'package:posnext/customerdetailsscreen.dart';
import '../screns/business_screens/day_opening_screen.dart';
import '../screns/business_screens/day_closing_screen.dart';

class MainSaleScreen extends StatefulWidget {
  const MainSaleScreen({super.key});

  @override
  State<MainSaleScreen> createState() => _MainSaleScreenState();
}

class _MainSaleScreenState extends State<MainSaleScreen> {
  // Cart State
  final List<Map<String, dynamic>> _cart = [];
  final TextEditingController _searchController = TextEditingController();
  
  // Transaction State
  String _invoiceId = "";
  int? _selectedRowIndex;
  double _discountPercentage = 0.0;

  @override
  void initState() {
    super.initState();
    _generateInvoiceId();
  }

  void _generateInvoiceId() {
    setState(() {
      _invoiceId = "INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";
    });
  }

  // Computed Properties
  double get _subTotal => _cart.fold(0.0, (sum, item) => sum + (item['price'] * item['qty']));
  double get _discountAmount => _subTotal * (_discountPercentage / 100);
  double get _totalAmount => _subTotal - _discountAmount;
  int get _totalItems => _cart.fold(0, (sum, item) => sum + (item['qty'] as int));

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item['id'] == product.id);
      int currentQtyInCart = index != -1 ? _cart[index]['qty'] : 0;

      if (currentQtyInCart + 1 > product.quantity) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Insufficient stock! Available: ${product.quantity}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      }

      if (index != -1) {
        _cart[index]['qty'] += 1;
        _cart[index]['amount'] = _cart[index]['qty'] * _cart[index]['price'];
      } else {
        _cart.add({
          'id': product.id,
          'barcode': product.barcode,
          'name': product.name,
          'price': product.price,
          'qty': 1,
          'amount': product.price,
          // 'tax': 0.0 // Logic for tax can be added here
        });
      }
    });
    _searchController.clear();
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      final item = _cart[index];
      int newQty = item['qty'] + change;
      
      if (newQty < 1) return; // Minimum 1
      
      // Check stock (optional, requires passing product or storing max qty in cart)
      // For now, assuming we can check against a stored 'maxQty' if we add it to cart map
      
      _cart[index]['qty'] = newQty;
      _cart[index]['amount'] = newQty * item['price'];
    });
  }

  void _removeFromCart(int index) {
    setState(() {
      _cart.removeAt(index);
      if (_selectedRowIndex == index) {
        _selectedRowIndex = null;
      } else if (_selectedRowIndex != null && _selectedRowIndex! > index) {
        _selectedRowIndex = _selectedRowIndex! - 1;
      }
    });
  }

  void _voidProduct() {
    if (_selectedRowIndex != null) {
      _removeFromCart(_selectedRowIndex!);
      setState(() {
        _selectedRowIndex = null;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a product to void"), duration: Duration(seconds: 1)),
      );
    }
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
      _discountPercentage = 0.0;
      _selectedRowIndex = null;
      _generateInvoiceId(); // New Invoice ID for next customer
    });
  }

  void _showDiscountDialog() {
    final TextEditingController discountController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Apply Discount"),
        content: TextField(
          controller: discountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: "Discount Percentage (%)",
            hintText: "e.g. 10",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final val = double.tryParse(discountController.text);
              if (val != null && val >= 0 && val <= 100) {
                setState(() {
                  _discountPercentage = val;
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSearch(String query, AppDatabase db) async {
    if (query.isEmpty) return;

    // 1. Try exact barcode match first
    final exactMatch = await db.getProductByBarcode(query);
    if (exactMatch != null) {
      _addToCart(exactMatch);
      return;
    }

    // 2. If not found, search by name (show list if multiple)
    final results = await db.searchProducts(query);
    if (results.length == 1) {
      _addToCart(results.first);
    } else if (results.length > 1) {
      // Show dialog to pick product
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Select Product"),
          content: SizedBox(
            width: 400,
            height: 300,
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (ctx, i) {
                final p = results[i];
                return ListTile(
                  title: Text(p.name),
                  subtitle: Text("${p.barcode} - \$${p.price}"),
                  onTap: () {
                    _addToCart(p);
                    Navigator.pop(ctx);
                  },
                );
              },
            ),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Product not found"), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _processPayment(String method, AppDatabase db) async {
    if (_cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cart is empty!")),
      );
      return;
    }

    bool paymentSuccess = false;

    if (method == "Cash") {
      final result = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => PayByCashPage(totalDue: _totalAmount))
      );
      paymentSuccess = result == true;
    } else if (method == "Card") {
       final result = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (_) => PayByCardPage(totalDue: _totalAmount))
      );
      paymentSuccess = result == true;
    } else {
      // Other methods (Gift Card etc.) - assume success for now or implement pages
      paymentSuccess = true; 
    }

    if (paymentSuccess) {
      // Save to DB
      final saleId = await db.createSale(
        SalesCompanion(
          invoiceNumber: drift.Value(_invoiceId),
          totalAmount: drift.Value(_totalAmount),
          discount: drift.Value(_discountAmount),
          paymentMethod: drift.Value(method),
          date: drift.Value(DateTime.now()),
        ),
        _cart.map((item) => SaleItemsCompanion(
          productId: drift.Value(item['id']),
          quantity: drift.Value(item['qty']),
          price: drift.Value(item['price']),
        )).toList(),
      );

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sale Completed! ID: $saleId"), backgroundColor: Colors.green),
      );
      _clearCart();
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

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
                          children: [
                            Text("Invoice: #$_invoiceId",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                            Text("Date: ${DateTime.now().toString().split(' ')[0]}",
                                style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    /// Search / Barcode Input
                    TextField(
                      controller: _searchController,
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
                      onSubmitted: (value) => _handleSearch(value, db),
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
                          // Expanded(child: Text("Tax")),
                          Expanded(child: Text("Qty")),
                          Expanded(child: Text("Amount")),
                          SizedBox(width: 40), // Action col
                        ],
                      ),
                    ),

                    /// Cart List
                    Expanded(
                      child: _cart.isEmpty
                        ? const Center(
                            child: Text("Your cart is empty",
                                style: TextStyle(color: Colors.grey)),
                          )
                        : ListView.separated(
                            itemCount: _cart.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (ctx, index) {
                              final item = _cart[index];
                              final isSelected = _selectedRowIndex == index;
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectedRowIndex = index;
                                  });
                                },
                                child: Container(
                                  color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(flex: 2, child: Text(item['barcode'], overflow: TextOverflow.ellipsis)),
                                      Expanded(flex: 4, child: Text(item['name'], overflow: TextOverflow.ellipsis)),
                                      Expanded(child: Text(item['price'].toString())),
                                      
                                      // Quantity with Buttons
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline, size: 20, color: Colors.grey),
                                              onPressed: () => _updateQuantity(index, -1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(item['qty'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline, size: 20, color: Colors.blue),
                                              onPressed: () => _updateQuantity(index, 1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      Expanded(child: Text(item['amount'].toStringAsFixed(2))),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                                        onPressed: () => _removeFromCart(index),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ),

                    const Divider(),

                    /// Summary
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SummaryRow(label: "Number of items:", value: "$_totalItems"),
                        SummaryRow(label: "Amount:", value: _subTotal.toStringAsFixed(2)),
                        SummaryRow(
                            label: "Discount (${_discountPercentage.toStringAsFixed(0)}%):",
                            value: "- ${_discountAmount.toStringAsFixed(2)}",
                            valueColor: Colors.red),
                        SummaryRow(
                          label: "Total:",
                          value: _totalAmount.toStringAsFixed(2),
                          isBold: true,
                        ),
                        SummaryRow(
                          label: "Balance:",
                          value: _totalAmount.toStringAsFixed(2), // Balance usually tracking remaining payment?
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
                      onTap: () => _processPayment("Cash", db),
                    ),
                    PosButton(
                      label: "Pay Card", 
                      color: Colors.blue[700]!,
                      onTap: () => _processPayment("Card", db),
                    ),
                    PosButton(
                      label: "Gift Card", 
                      color: Colors.green,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiftCardScreen())),
                    ),
                    PosButton(
                      label: "Discount", 
                      color: Colors.orange,
                      onTap: _showDiscountDialog, 
                    ),
                    PosButton(
                      label: "Stock Details", 
                      color: Colors.grey,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StockDetailsPage())),
                    ),
                    PosButton(
                      label: "Day/Opening Closing", 
                      color: Colors.grey[700]!,
                      onTap: () async {
                        final database = Provider.of<AppDatabase>(context, listen: false);
                        final currentDay = await database.getCurrentBusinessDay();

                        if (!context.mounted) return;

                        if (currentDay == null) {
                          // Day is closed, open it
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DayOpeningScreen()),
                          );
                        } else {
                          // Day is open, close it
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DayClosingScreen()),
                          );
                        }
                      }, 
                    ),
                    PosButton(
                      label: "Return", 
                      color: Colors.red[300]!,
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
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiftCardScreen())), 
                    ),
                    PosButton(
                      label: "Void Product", 
                      color: Colors.red,
                      onTap: _voidProduct, 
                    ),
                    PosButton(
                      label: "Void Payment", 
                      color: Colors.red[800]!,
                      onTap: () {}, 
                    ),
                    PosButton(
                      label: "Clean Screen", 
                      color: Colors.purple,
                      onTap: _clearCart,
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
