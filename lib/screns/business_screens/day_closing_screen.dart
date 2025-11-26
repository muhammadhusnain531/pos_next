import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';

class DayClosingScreen extends StatefulWidget {
  const DayClosingScreen({super.key});

  @override
  State<DayClosingScreen> createState() => _DayClosingScreenState();
}

class _DayClosingScreenState extends State<DayClosingScreen> {
  final TextEditingController _countedCashController = TextEditingController();
  bool isLoading = false;
  BusinessDay? _currentDay;
  double _expectedCash = 0.0;
  double _discrepancy = 0.0;

  @override
  void initState() {
    super.initState();
    _loadCurrentDay();
    _countedCashController.addListener(_calculateDiscrepancy);
  }

  @override
  void dispose() {
    _countedCashController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentDay() async {
    setState(() => isLoading = true);
    try {
      final database = Provider.of<AppDatabase>(context, listen: false);
      final day = await database.getCurrentBusinessDay();
      
      if (day != null) {
        print("DEBUG: Day Loaded: ${day.toJson()}");
        print("DEBUG: Opening Balance: ${day.openingBalance}");
        print("DEBUG: Total Cash Sales: ${day.totalCashSales}");
        print("DEBUG: Total Card Sales: ${day.totalCardSales}");
        
        setState(() {
          _currentDay = day;
          // Expected Cash = Opening Balance + Cash Sales
          _expectedCash = day.openingBalance + day.totalCashSales;
          print("DEBUG: Expected Cash Calculated: $_expectedCash");
          _calculateDiscrepancy();
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading day data: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _calculateDiscrepancy() {
    final counted = double.tryParse(_countedCashController.text) ?? 0.0;
    setState(() {
      _discrepancy = counted - _expectedCash;
    });
  }

  Future<void> _closeDay() async {
    if (_currentDay == null) return;
    
    if (_countedCashController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the counted cash amount')),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final double countedCash = double.parse(_countedCashController.text);
      final database = Provider.of<AppDatabase>(context, listen: false);
      
      await database.closeBusinessDay(
        _currentDay!.id,
        countedCash,
        _discrepancy,
        'Admin', // TODO: Replace with actual user
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Business Day Closed Successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error closing day: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading && _currentDay == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentDay == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Day Closing')),
        body: const Center(child: Text('No active business day found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Closing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'End of Business Day',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // Summary Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Opening Balance:', _currentDay!.openingBalance),
                        const Divider(),
                        _buildSummaryRow('Total Cash Sales:', _currentDay!.totalCashSales),
                        _buildSummaryRow('Total Card Sales:', _currentDay!.totalCardSales),
                        _buildSummaryRow('Total Gift Card Sales:', _currentDay!.totalGiftCardSales),
                        _buildSummaryRow('Total Other Sales:', _currentDay!.totalOtherSales),
                        const Divider(),
                        _buildSummaryRow('Total Sales:', 
                          _currentDay!.totalCashSales + 
                          _currentDay!.totalCardSales + 
                          _currentDay!.totalGiftCardSales + 
                          _currentDay!.totalOtherSales, 
                          isBold: true),
                        const Divider(),
                        _buildSummaryRow('Expected Cash in Drawer:', _expectedCash, isBold: true),
                        _buildSummaryRow('Total Expected Balance (All Modes):', 
                          _currentDay!.openingBalance + 
                          _currentDay!.totalCashSales + 
                          _currentDay!.totalCardSales + 
                          _currentDay!.totalGiftCardSales + 
                          _currentDay!.totalOtherSales, 
                          isBold: true, valueColor: Colors.blue),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Enter Counted Cash:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _countedCashController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                      hintText: '0.00',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Discrepancy Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _discrepancy == 0 
                          ? Colors.green[50] 
                          : (_discrepancy > 0 ? Colors.blue[50] : Colors.red[50]),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _discrepancy == 0 
                            ? Colors.green 
                            : (_discrepancy > 0 ? Colors.blue : Colors.red),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discrepancy (Over/Short):', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '\$ ${_discrepancy.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _discrepancy == 0 
                                ? Colors.green 
                                : (_discrepancy > 0 ? Colors.blue : Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : _closeDay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('CLOSE DAY', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _calculateDiscrepancy() {
    final counted = double.tryParse(_countedCashController.text) ?? 0.0;
    setState(() {
      _discrepancy = counted - _expectedCash;
    });
  }

  Future<void> _closeDay() async {
    if (_currentDay == null) return;
    
    if (_countedCashController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the counted cash amount')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final double countedCash = double.parse(_countedCashController.text);
      final database = Provider.of<AppDatabase>(context, listen: false);
      
      await database.closeBusinessDay(
        _currentDay!.id,
        countedCash,
        _discrepancy,
        'Admin', // TODO: Replace with actual user
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Business Day Closed Successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error closing day: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading && _currentDay == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_currentDay == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Day Closing')),
        body: const Center(child: Text('No active business day found.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Closing'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Card(
            elevation: 4,
            child: Container(
              width: 500,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'End of Business Day',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  
                  // Summary Section
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow('Opening Balance:', _currentDay!.openingBalance),
                        const Divider(),
                        _buildSummaryRow('Total Cash Sales:', _currentDay!.totalCashSales),
                        _buildSummaryRow('Total Card Sales:', _currentDay!.totalCardSales),
                        _buildSummaryRow('Total Gift Card Sales:', _currentDay!.totalGiftCardSales),
                        _buildSummaryRow('Total Other Sales:', _currentDay!.totalOtherSales),
                        const Divider(),
                        _buildSummaryRow('Total Sales:', 
                          _currentDay!.totalCashSales + 
                          _currentDay!.totalCardSales + 
                          _currentDay!.totalGiftCardSales + 
                          _currentDay!.totalOtherSales, 
                          isBold: true),
                        const Divider(),
                        _buildSummaryRow('Expected Cash in Drawer:', _expectedCash, isBold: true),
                        _buildSummaryRow('Total Expected Balance (All Modes):', 
                          _currentDay!.openingBalance + 
                          _currentDay!.totalCashSales + 
                          _currentDay!.totalCardSales + 
                          _currentDay!.totalGiftCardSales + 
                          _currentDay!.totalOtherSales, 
                          isBold: true, valueColor: Colors.blue),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Enter Counted Cash:',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _countedCashController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      prefixText: '\$ ',
                      border: OutlineInputBorder(),
                      hintText: '0.00',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Discrepancy Display
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _discrepancy == 0 
                          ? Colors.green[50] 
                          : (_discrepancy > 0 ? Colors.blue[50] : Colors.red[50]),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _discrepancy == 0 
                            ? Colors.green 
                            : (_discrepancy > 0 ? Colors.blue : Colors.red),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Discrepancy (Over/Short):', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '\$ ${_discrepancy.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _discrepancy == 0 
                                ? Colors.green 
                                : (_discrepancy > 0 ? Colors.blue : Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _closeDay,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('CLOSE DAY', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, double value, {bool isBold = false, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            '\$ ${value.toStringAsFixed(2)}',
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
