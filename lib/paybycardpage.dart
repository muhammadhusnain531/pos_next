import 'package:flutter/material.dart';
import 'package:posnext/paybycashpage.dart';

class PayByCardPage extends StatefulWidget {
  final double totalDue;

  const PayByCardPage({Key? key, this.totalDue = 55.00}) : super(key: key);

  @override
  State<PayByCardPage> createState() => _PayByCardPageState();
}

class _PayByCardPageState extends State<PayByCardPage> {
  String? _selectedMethod;
  bool _isProcessing = false;

  void _handleFullPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a payment method"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Payment Successful"),
        content: Text("Paid full amount Rs. ${widget.totalDue.toStringAsFixed(2)} via $_selectedMethod"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Return TRUE
              Navigator.of(context).pop(true);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _handleSplitPayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please select a payment method first"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final double? cardAmount = await showDialog<double>(
      context: context,
      builder: (context) {
        String amountStr = "";
        return AlertDialog(
          title: Text("Enter Amount for $_selectedMethod"),
          content: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: const InputDecoration(prefixText: "Rs. ", hintText: "0.00", border: OutlineInputBorder()),
            onChanged: (val) => amountStr = val,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(amountStr);
                if (val != null && val > 0 && val <= widget.totalDue) {
                  Navigator.pop(context, val);
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    if (cardAmount == null) return;

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });

    final double remaining = widget.totalDue - cardAmount;

    if (remaining <= 0.01) {
      _showSuccessDialog(cardAmount);
    } else {
      // Go to Cash page
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PayByCashPage(totalDue: remaining),
        ),
      );
      
      // If cash payment succeeded, close card page with success
      if (result == true) {
        Navigator.pop(context, true);
      }
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Payment Successful"),
        content: Text("Paid Rs. ${amount.toStringAsFixed(2)} via $_selectedMethod"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(true);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 24, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Pay by Card', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  Text('Order #12345', style: TextStyle(color: Colors.grey[600])),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Payment Amount', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 8),
              TextField(
                enabled: false,
                controller: TextEditingController(text: widget.totalDue.toStringAsFixed(2)),
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                decoration: const InputDecoration(
                  prefixText: 'Rs. ',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Select Payment Method', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _PaymentMethodButton(icon: Icons.account_balance, label: 'HBL', isSelected: _selectedMethod == 'HBL', onTap: () => setState(() => _selectedMethod = 'HBL')),
                  const SizedBox(width: 10),
                  _PaymentMethodButton(icon: Icons.credit_card, label: 'Credit', isSelected: _selectedMethod == 'Credit Card', onTap: () => setState(() => _selectedMethod = 'Credit Card')),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handleFullPayment,
                  child: _isProcessing ? const CircularProgressIndicator(color: Colors.white) : const Text("Proceed to Pay"),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: _isProcessing ? null : _handleSplitPayment,
                  child: const Text("Also Add Cash"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentMethodButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodButton({Key? key, required this.icon, required this.label, required this.isSelected, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 18),
          backgroundColor: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF4F6F8),
          side: BorderSide(color: isSelected ? const Color(0xFF4D4AE8) : const Color(0xFFE5E7EB), width: isSelected ? 2 : 1),
        ),
        child: Column(children: [Icon(icon, color: isSelected ? const Color(0xFF4D4AE8) : Colors.black), Text(label)]),
      ),
    );
  }
}
