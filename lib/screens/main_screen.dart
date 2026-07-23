import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift; // Alias for drift columns/values
import 'package:google_fonts/google_fonts.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/services/auth_service.dart';
import 'package:posnext/paybycashpage.dart';
import 'package:posnext/paybycardpage.dart';
import 'package:posnext/giftcardscreen.dart';
import 'package:posnext/homedeliverypage.dart';
import 'package:posnext/salereportpage.dart';
import 'package:posnext/stockdetailspage.dart';
import 'package:posnext/addproductscreen.dart';
import 'package:posnext/customerdetailsscreen.dart';
import '../screns/customer_screens/customer_list_screen.dart';
import '../screns/business_screens/staff_list_screen.dart';
import '../screns/business_screens/appointment_screen.dart';
import '../screns/business_screens/day_opening_screen.dart';
import '../theme/colors.dart';
import 'login_screen.dart';

import '../screns/business_screens/day_closing_screen.dart';
import 'package:posnext/services/receipt_service.dart';
import 'package:posnext/services/printer_service.dart';

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

      if (!product.isService && currentQtyInCart + 1 > product.quantity) {
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
          'isService': product.isService,
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
                  subtitle: Text("${p.barcode} - Rs. ${p.price}"),
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
      final auth = Provider.of<AuthService>(context, listen: false);
      if (auth.currentBranch == null) {
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error: No active branch linked to user.")),
        );
        return;
      }

      // Save to DB
      final saleId = await db.createSale(
        SalesCompanion(
          branchId: drift.Value(auth.currentBranch!.id),
          userId: drift.Value(auth.currentUser?.id),
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

      // --- Generate & Print Receipt ---
      try {
        final receiptService = ReceiptService();
        final printerService = PrinterService();
        
        // Reconstruct Sale object (since createSale returns ID only)
        final sale = Sale(
          id: saleId,
          branchId: auth.currentBranch!.id,
          userId: auth.currentUser?.id,
          invoiceNumber: _invoiceId,
          totalAmount: _totalAmount,
          discount: _discountAmount,
          paymentMethod: method,
          date: DateTime.now(),
        );

        // Reconstruct SaleItems
        final saleItems = _cart.map((item) => SaleItem(
          id: 0, // Placeholder
          saleId: saleId,
          productId: item['id'],
          quantity: item['qty'],
          price: item['price'],
        )).toList();

        // Get Products (we have them in cart but need Product objects)
        // Ideally we fetch from DB or map from cart. Mapping from cart is faster here.
        final products = _cart.map((item) => Product(
          id: item['id'],
          branchId: auth.currentBranch!.id,
          name: item['name'],
          barcode: item['barcode'],
          quantity: 0, // Not needed for receipt display
          price: item['price'],
          status: '',
          isService: item['isService'] ?? false,
        )).toList();

        final pdf = await receiptService.generateReceipt(
          sale: sale,
          items: saleItems,
          products: products,
          branch: auth.currentBranch!,
          user: auth.currentUser,
          customerName: null, // Pass customer name if available
        );

        await printerService.printReceipt(pdf);

      } catch (e) {
        print("Printing Error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Printing failed: $e"), backgroundColor: Colors.orange),
        );
      }

      _clearCart();
    }
  }

  void _showReturnDialog() {
    final TextEditingController barcodeController = TextEditingController();
    final TextEditingController qtyController = TextEditingController(text: "1");
    String refundMethod = "Cash";

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          return AlertDialog(
            title: const Text("Return Product / Service"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: barcodeController,
                  decoration: const InputDecoration(
                    labelText: "Product/Service Barcode",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: qtyController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Quantity to Return",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: refundMethod,
                  decoration: const InputDecoration(
                    labelText: "Refund Method",
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "Cash", child: Text("Cash")),
                    DropdownMenuItem(value: "Card", child: Text("Card")),
                    DropdownMenuItem(value: "Gift Card", child: Text("Gift Card")),
                  ],
                  onChanged: (val) {
                    if (val != null) {
                      setDialogState(() {
                        refundMethod = val;
                      });
                    }
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () {
                  final qty = int.tryParse(qtyController.text) ?? 1;
                  if (barcodeController.text.isNotEmpty && qty > 0) {
                    Navigator.pop(ctx);
                    final db = Provider.of<AppDatabase>(context, listen: false);
                    _processReturn(barcodeController.text, qty, refundMethod, db);
                  }
                },
                child: const Text("Process Return"),
              ),
            ],
          );
        }
      ),
    );
  }

  Future<void> _processReturn(String barcode, int qty, String method, AppDatabase db) async {
    // 1. Fetch product/service
    final product = await db.getProductByBarcode(barcode);
    if (product == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: Product/Service not found."), backgroundColor: Colors.red),
      );
      return;
    }

    final auth = Provider.of<AuthService>(context, listen: false);
    if (auth.currentBranch == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No active branch selected.")),
      );
      return;
    }

    // Generate Return Invoice ID
    final returnInvoiceId = "RET-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";
    
    // Return amount is negative
    final returnTotal = -(product.price * qty);

    try {
      final saleId = await db.createSale(
        SalesCompanion(
          branchId: drift.Value(auth.currentBranch!.id),
          userId: drift.Value(auth.currentUser?.id),
          invoiceNumber: drift.Value(returnInvoiceId),
          totalAmount: drift.Value(returnTotal),
          discount: const drift.Value(0.0),
          paymentMethod: drift.Value(method),
          date: drift.Value(DateTime.now()),
        ),
        [
          SaleItemsCompanion(
            productId: drift.Value(product.id),
            quantity: drift.Value(-qty), // Negative quantity for return
            price: drift.Value(product.price),
          )
        ],
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Return Processed! Sale ID: $saleId"), backgroundColor: Colors.green),
      );

      // --- Print Return Receipt ---
      try {
        final receiptService = ReceiptService();
        final printerService = PrinterService();
        
        final sale = Sale(
          id: saleId,
          branchId: auth.currentBranch!.id,
          userId: auth.currentUser?.id,
          invoiceNumber: returnInvoiceId,
          totalAmount: returnTotal,
          discount: 0.0,
          paymentMethod: method,
          date: DateTime.now(),
        );

        final saleItems = [
          SaleItem(
            id: 0,
            saleId: saleId,
            productId: product.id,
            quantity: -qty,
            price: product.price,
          )
        ];

        final products = [
          product.copyWith(name: "RETURN: ${product.name}")
        ];

        final pdf = await receiptService.generateReceipt(
          sale: sale,
          items: saleItems,
          products: products,
          branch: auth.currentBranch!,
          user: auth.currentUser,
          customerName: null,
        );

        await printerService.printReceipt(pdf);
      } catch (e) {
        print("Printing Return Receipt Error: $e");
      }

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Return Failed: $e"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      backgroundColor: AppColors.beigeLight,
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
                  color: AppColors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(2),
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
                          width: 140,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: AppColors.border),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "CŌNTOR 369",
                                style: GoogleFonts.playfairDisplay(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.4,
                                  color: AppColors.text,
                                ),
                              ),
                              Text(
                                "SALON PORTAL",
                                style: GoogleFonts.dmSans(
                                  fontSize: 7,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.8,
                                  color: AppColors.textLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Invoice: #$_invoiceId",
                              style: GoogleFonts.dmSans(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.text,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              "Date: ${DateTime.now().toString().split(' ')[0]}",
                              style: GoogleFonts.dmSans(
                                fontSize: 12,
                                color: AppColors.textLight,
                              ),
                            ),
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
                        prefixIcon: const Icon(Icons.qr_code_scanner, color: AppColors.textLight),
                        suffixIcon: const Icon(Icons.search, color: AppColors.textLight),
                        filled: true,
                        fillColor: AppColors.beigeLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(2),
                          borderSide: const BorderSide(color: AppColors.mauve, width: 1.5),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      onSubmitted: (value) => _handleSearch(value, db),
                    ),
                    
                    const SizedBox(height: 16),

                    const Divider(),

                    /// Cart Table Header
                    Container(
                      color: AppColors.beigeLight,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: Text(
                              "BARCODE",
                              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMid, letterSpacing: 1.0),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: Text(
                              "DESCRIPTION",
                              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMid, letterSpacing: 1.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "PRICE",
                              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMid, letterSpacing: 1.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "QTY",
                              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMid, letterSpacing: 1.0),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "AMOUNT",
                              style: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textMid, letterSpacing: 1.0),
                            ),
                          ),
                          const SizedBox(width: 40), // Action col
                        ],
                      ),
                    ),

                    /// Cart List
                    Expanded(
                      child: _cart.isEmpty
                        ? Center(
                            child: Text(
                              "Your cart is empty",
                              style: GoogleFonts.dmSans(color: AppColors.textLight, fontSize: 14),
                            ),
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
                                  color: isSelected ? AppColors.blushPale : null,
                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          item['barcode'],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.dmSans(color: AppColors.textMid),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(
                                          item['name'],
                                          overflow: TextOverflow.ellipsis,
                                          style: GoogleFonts.dmSans(color: AppColors.text, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item['price'].toString(),
                                          style: GoogleFonts.dmSans(color: AppColors.text),
                                        ),
                                      ),
                                      
                                      // Quantity with Buttons
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline, size: 20, color: AppColors.zinc),
                                              onPressed: () => _updateQuantity(index, -1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                              child: Text(
                                                item['qty'].toString(),
                                                style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: AppColors.text),
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline, size: 20, color: AppColors.mauve),
                                              onPressed: () => _updateQuantity(index, 1),
                                              padding: EdgeInsets.zero,
                                              constraints: const BoxConstraints(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      
                                      Expanded(
                                        child: Text(
                                          item['amount'].toStringAsFixed(2),
                                          style: GoogleFonts.dmSans(fontWeight: FontWeight.bold, color: AppColors.text),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: AppColors.bad, size: 20),
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
                            valueColor: AppColors.bad),
                        SummaryRow(
                          label: "Total:",
                          value: _totalAmount.toStringAsFixed(2),
                          isBold: true,
                          valueColor: AppColors.mauveDeep,
                        ),
                        SummaryRow(
                          label: "Balance:",
                          value: _totalAmount.toStringAsFixed(2),
                          isBold: true,
                          valueColor: AppColors.mauveDeep,
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
                  color: AppColors.white,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: [
                    PosButton(
                      label: "Pay Cash", 
                      color: AppColors.ok,
                      onTap: () => _processPayment("Cash", db),
                    ),
                    PosButton(
                      label: "Pay Card", 
                      color: AppColors.mauve,
                      onTap: () => _processPayment("Card", db),
                    ),
                    PosButton(
                      label: "Gift Card", 
                      color: AppColors.blushDeep,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiftCardScreen())),
                    ),
                    PosButton(
                      label: "Discount", 
                      color: AppColors.blush,
                      onTap: _showDiscountDialog, 
                    ),
                    PosButton(
                      label: "Stock Details", 
                      color: AppColors.zinc,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StockDetailsPage())),
                    ),
                    PosButton(
                      label: "Day/Opening Closing", 
                      color: AppColors.zincDark,
                      onTap: () async {
                        try {
                          final database = Provider.of<AppDatabase>(context, listen: false);
                          final auth = Provider.of<AuthService>(context, listen: false);
                          if (auth.currentBranch == null) {
                             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No active branch")));
                             return;
                          }
                          final currentDay = await database.getCurrentBusinessDay(auth.currentBranch!.id);

                          if (!context.mounted) return;

                          if (currentDay == null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DayOpeningScreen()),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DayClosingScreen()),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Error: $e")),
                          );
                        }
                      }, 
                    ),
                    PosButton(
                      label: "Stylists Directory", 
                      color: AppColors.mauve,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const StaffListScreen())), 
                    ),
                    PosButton(
                      label: "Bookings Scheduler", 
                      color: AppColors.mauveDeep,
                      onTap: () async {
                        final result = await Navigator.push<Map<String, dynamic>>(
                          context,
                          MaterialPageRoute(builder: (context) => const AppointmentScreen()),
                        );
                        if (result != null && result['action'] == 'checkout') {
                          final service = result['service'] as Product;
                          final appt = result['appointment'] as Appointment;
                          _addToCart(service);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Added ${service.name} for appointment #${appt.id} to cart"),
                              backgroundColor: AppColors.ok,
                            ),
                          );
                        }
                      },
                    ),
                    PosButton(
                      label: "Issue Gift Card", 
                      color: AppColors.blushDeep,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GiftCardScreen())), 
                    ),
                    PosButton(
                      label: "Void Product", 
                      color: AppColors.bad,
                      onTap: _voidProduct, 
                    ),
                    PosButton(
                      label: "Return Item", 
                      color: AppColors.warn,
                      onTap: _showReturnDialog, 
                    ),
                    PosButton(
                      label: "Clean Screen", 
                      color: AppColors.zincPale,
                      textColor: AppColors.text,
                      onTap: _clearCart,
                    ),
                    PosButton(
                      label: "Customers Directory", 
                      color: AppColors.mauve,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CustomerListScreen(isSelectionMode: false))),
                    ),

                    PosButton(
                      label: "Reports", 
                      color: AppColors.text,
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SaleReportPage())),
                    ),
                    PosButton(
                      label: "Logout",
                      color: AppColors.zincDark,
                      onTap: () {
                        final auth = Provider.of<AuthService>(context, listen: false);
                        auth.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                          (route) => false,
                        );
                      },
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
          Text(
            label,
            style: GoogleFonts.dmSans(
              color: AppColors.text,
              fontSize: 13,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.dmSans(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: valueColor ?? AppColors.text,
              fontSize: 13,
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
  final Color? textColor;
  final VoidCallback? onTap;

  const PosButton({
    super.key, 
    required this.label, 
    required this.color,
    this.textColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor ?? Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: color == AppColors.zincPale 
              ? const BorderSide(color: AppColors.border, width: 1) 
              : BorderSide.none,
          borderRadius: BorderRadius.circular(2),
        ),
        padding: const EdgeInsets.all(8),
      ),
      onPressed: onTap ?? () {},
      child: Text(
        label.toUpperCase(),
        textAlign: TextAlign.center,
        style: GoogleFonts.dmSans(
          color: textColor ?? Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
