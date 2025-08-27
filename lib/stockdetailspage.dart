import 'package:flutter/material.dart';

class StockDetailsPage extends StatelessWidget {
  const StockDetailsPage({Key? key}) : super(key: key);

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 16,
                  spreadRadius: 0)
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Stock Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Manage and track your product inventory.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text('Add Product'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF3578F6),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                        ),
                        onPressed: () {},
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.print),
                        label: const Text('Print Report'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFF4F6F8),
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 16),
                          elevation: 0,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Search and Filter
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search by product name, SKU...',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF4F6F8),
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: 'All Categories',
                    items: [
                      DropdownMenuItem(
                        child: Text('All Categories'),
                        value: 'All Categories',
                      ),
                    ],
                    onChanged: (_) {},
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.filter_list),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Table
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DataTable(
                  headingRowHeight: 48,
                  dataRowHeight: 72,
                  columns: const [
                    DataColumn(label: SizedBox(width: 32, child: Checkbox(value: false, onChanged: null))),
                    DataColumn(label: Text('PRODUCT NAME', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('SKU', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('CATEGORY', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('QUANTITY', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('PRICE', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('STATUS', style: TextStyle(fontWeight: FontWeight.bold))),
                    DataColumn(label: Text('ACTIONS', style: TextStyle(fontWeight: FontWeight.bold))),
                  ],
                  rows: [
                    _buildProductRow(
                      context,
                      image: 'https://img.icons8.com/color/48/000000/smartphone.png',
                      name: 'Smart Phone X',
                      sku: 'SP-X-2023',
                      category: 'Electronics',
                      quantity: '250',
                      price: '\$999.00',
                      status: 'In Stock',
                      statusColor: Colors.green.shade100,
                      statusTextColor: Colors.green,
                    ),
                    _buildProductRow(
                      context,
                      image: 'https://img.icons8.com/color/48/000000/laptop.png',
                      name: 'Pro Laptop 15"',
                      sku: 'LP-PRO-15',
                      category: 'Electronics',
                      quantity: '120',
                      price: '\$1499.00',
                      status: 'In Stock',
                      statusColor: Colors.green.shade100,
                      statusTextColor: Colors.green,
                    ),
                    _buildProductRow(
                      context,
                      image: 'https://img.icons8.com/color/48/000000/t-shirt.png',
                      name: 'Classic T-Shirt',
                      sku: 'TS-CL-M',
                      category: 'Apparel',
                      quantity: '50',
                      price: '\$25.00',
                      status: 'Low Stock',
                      statusColor: Colors.yellow.shade100,
                      statusTextColor: Colors.orange,
                    ),
                    _buildProductRow(
                      context,
                      image: 'https://img.icons8.com/color/48/000000/coffee.png',
                      name: 'Organic Coffee Beans',
                      sku: 'CB-ORG-1KG',
                      category: 'Groceries',
                      quantity: '0',
                      price: '\$15.50',
                      status: 'Out of Stock',
                      statusColor: Colors.red.shade100,
                      statusTextColor: Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Pagination and Entries info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Showing 1 to 4 of 100 Entries',
                      style: TextStyle(fontSize: 15, color: Colors.grey)),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Prev'),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text('Next'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static DataRow _buildProductRow(
      BuildContext context, {
        required String image,
        required String name,
        required String sku,
        required String category,
        required String quantity,
        required String price,
        required String status,
        required Color statusColor,
        required Color statusTextColor,
      }) {
    return DataRow(
      cells: [
        const DataCell(Checkbox(value: false, onChanged: null)),
        DataCell(Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(image),
              radius: 24,
            ),
            const SizedBox(width: 16),
            Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        )),
        DataCell(Text(sku)),
        DataCell(Text(category)),
        DataCell(Text(quantity)),
        DataCell(Text(price)),
        DataCell(Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: statusTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        )),
        DataCell(Row(
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF3578F6)),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {},
            ),
          ],
        )),
      ],
    );
  }
}