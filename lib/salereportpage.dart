import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/services/auth_service.dart';

class SaleReportPage extends StatefulWidget {
  const SaleReportPage({Key? key}) : super(key: key);

  @override
  State<SaleReportPage> createState() => _SaleReportPageState();
}

class _SaleReportPageState extends State<SaleReportPage> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 7));
  DateTime _endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);

    final auth = Provider.of<AuthService>(context, listen: false);
    
    if (auth.currentBranch == null) {
      return const Scaffold(body: Center(child: Text("No active branch")));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Sales Report',
          style: TextStyle(
            color: Color(0xFF2D3748),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4A5568)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: FutureBuilder<List<Sale>>(
          future: db.getSalesByDateRange(auth.currentBranch!.id, _startDate, _endDate),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            final sales = snapshot.data ?? [];
            
            // Calculate Summary
            final double totalSales = sales.fold(0, (sum, s) => sum + s.totalAmount);
            final int totalOrders = sales.length;
            final double totalDiscount = sales.fold(0, (sum, s) => sum + s.discount);
            final double avgOrder = totalOrders > 0 ? totalSales / totalOrders : 0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card with Date Range
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sales Report',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              final range = await showDateRangePicker(
                                context: context, 
                                firstDate: DateTime(2000), 
                                lastDate: DateTime(2100)
                              );
                              if (range != null) {
                                setState(() {
                                  _startDate = range.start;
                                  _endDate = range.end;
                                });
                              }
                            },
                            child: Text("${_startDate.toString().split(' ')[0]} to ${_endDate.toString().split(' ')[0]}"),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Summary Cards
                Row(
                  children: [
                    Expanded(child: _buildSummaryCard('Total Sales', '\$${totalSales.toStringAsFixed(2)}', Icons.trending_up, Colors.green)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Total Orders', '$totalOrders', Icons.receipt_long, Colors.blue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Avg Order', '\$${avgOrder.toStringAsFixed(2)}', Icons.assessment, Colors.purple)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSummaryCard('Discount', '\$${totalDiscount.toStringAsFixed(2)}', Icons.local_offer, Colors.orange)),
                  ],
                ),

                const SizedBox(height: 24),

                // Data Table
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: sales.isEmpty 
                      ? const Center(child: Text("No sales found for this period"))
                      : SingleChildScrollView(
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text("Invoice")),
                            DataColumn(label: Text("Date")),
                            DataColumn(label: Text("Payment")),
                            DataColumn(label: Text("Amount")),
                          ],
                          rows: sales.map((sale) {
                            return DataRow(cells: [
                              DataCell(Text(sale.invoiceNumber)),
                              DataCell(Text(sale.date.toString().split(' ')[0])),
                              DataCell(Text(sale.paymentMethod)),
                              DataCell(Text("\$${sale.totalAmount.toStringAsFixed(2)}")),
                            ]);
                          }).toList(),
                        ),
                      ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}
