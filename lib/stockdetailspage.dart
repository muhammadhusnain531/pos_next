import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/addproductscreen.dart';

class StockDetailsPage extends StatefulWidget {
  const StockDetailsPage({super.key});

  @override
  State<StockDetailsPage> createState() => _StockDetailsPageState();
}

class _StockDetailsPageState extends State<StockDetailsPage> {
  String _searchQuery = "";
  String _categoryFilter = "All Categories";

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Stock Details", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Manage Inventory",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text("Add Product"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3578F6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddProductScreen()),
                    ).then((_) => setState(() {})); // Refresh on return
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search by name or barcode...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
            const SizedBox(height: 24),

            // Data Table
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: FutureBuilder<List<Product>>(
                  future: db.getAllProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No products found. Add one!"));
                    }

                    final products = snapshot.data!.where((p) {
                      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) || 
                                            p.barcode.contains(_searchQuery);
                      // Add category filter logic if you have categories in DB
                      return matchesSearch;
                    }).toList();

                    return SingleChildScrollView(
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Barcode")),
                          DataColumn(label: Text("Price")),
                          DataColumn(label: Text("Qty")),
                          DataColumn(label: Text("Status")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: products.map((product) {
                          return DataRow(cells: [
                            DataCell(Text(product.name)),
                            DataCell(Text(product.barcode)),
                            DataCell(Text("Rs. ${product.price.toStringAsFixed(2)}")),
                            DataCell(Text(product.quantity.toString())),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: product.quantity > 0 ? Colors.green[100] : Colors.red[100],
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: Text(
                                  product.status,
                                  style: TextStyle(
                                    color: product.quantity > 0 ? Colors.green[800] : Colors.red[800]
                                  ),
                                ),
                              )
                            ),
                            DataCell(Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () async {
                                    await db.deleteProduct(product.id);
                                    setState(() {}); // Refresh list
                                  },
                                ),
                              ],
                            )),
                          ]);
                        }).toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
