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

    // Simulate network delay / transaction processing
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
        content: Text("Paid full amount \$${widget.totalDue.toStringAsFixed(2)} via $_selectedMethod"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close dialog
              Navigator.of(context).pop(); // Go back to main screen
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

    // Prompt user for the Card amount
    final double? cardAmount = await showDialog<double>(
      context: context,
      builder: (context) {
        String amountStr = "";
        return AlertDialog(
          title: Text("Enter Amount for $_selectedMethod"),
          content: TextField(
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            autofocus: true,
            decoration: const InputDecoration(
              prefixText: "\$ ",
              hintText: "0.00",
              border: OutlineInputBorder(),
            ),
            onChanged: (val) => amountStr = val,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final val = double.tryParse(amountStr);
                if (val != null && val > 0 && val <= widget.totalDue) {
                  Navigator.pop(context, val);
                } else {
                  // Invalid amount logic (visual feedback or ignore)
                }
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );

    if (cardAmount == null) return; // User cancelled

    setState(() {
      _isProcessing = true;
    });

    // Simulate processing the card part
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _isProcessing = false;
    });

    // Calculate remaining for Cash
    final double remaining = widget.totalDue - cardAmount;

    if (remaining <= 0.01) {
      // Practically paid in full
      _showSuccessDialog(cardAmount);
    } else {
      // Navigate to Cash Page for the rest
      // We assume if they come back from Cash Page, the transaction is done.
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PayByCashPage(totalDue: remaining),
        ),
      ).then((_) {
         // Close the card page when returning from cash page (assuming transaction flow ended)
         Navigator.pop(context);
      });
    }
  }

  void _showSuccessDialog(double amount) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Payment Successful"),
        content: Text("Paid \$${amount.toStringAsFixed(2)} via $_selectedMethod"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
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
              BoxShadow(
                color: Colors.black.withOpacity(0.07),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and order info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pay by Card',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Order #12345',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Date: ${DateTime.now().toString().split(' ')[0]}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Payment Amount
              const Text(
                'Payment Amount',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 56,
                child: TextField(
                  enabled: false, // Read-only, displays total due
                  controller: TextEditingController(text: widget.totalDue.toStringAsFixed(2)),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Payment Method
              const Text(
                'Select Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              // Bank options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PaymentMethodButton(
                    icon: Icons.account_balance,
                    label: 'HBL',
                    isSelected: _selectedMethod == 'HBL',
                    onTap: () => setState(() => _selectedMethod = 'HBL'),
                  ),
                  _PaymentMethodButton(
                    icon: Icons.account_balance,
                    label: 'Meezan',
                    isSelected: _selectedMethod == 'Meezan',
                    onTap: () => setState(() => _selectedMethod = 'Meezan'),
                  ),
                  _PaymentMethodButton(
                    icon: Icons.account_balance,
                    label: 'ABL',
                    isSelected: _selectedMethod == 'ABL',
                    onTap: () => setState(() => _selectedMethod = 'ABL'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Card & QR options
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PaymentMethodButton(
                    icon: Icons.credit_card,
                    label: 'Credit Card',
                    isSelected: _selectedMethod == 'Credit Card',
                    onTap: () => setState(() => _selectedMethod = 'Credit Card'),
                  ),
                  _PaymentMethodButton(
                    icon: Icons.credit_card,
                    label: 'Debit Card',
                    isSelected: _selectedMethod == 'Debit Card',
                    onTap: () => setState(() => _selectedMethod = 'Debit Card'),
                  ),
                  _PaymentMethodButton(
                    icon: Icons.qr_code_2,
                    label: 'QR Code',
                    isSelected: _selectedMethod == 'QR Code',
                    onTap: () => setState(() => _selectedMethod = 'QR Code'),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Proceed to Pay button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Icon(Icons.payment, color: Colors.white),
                  label: Text(
                    _isProcessing ? 'Processing...' : 'Proceed to Pay',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4D4AE8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isProcessing ? null : _handleFullPayment,
                ),
              ),
              const SizedBox(height: 16),
              // Also Add Cash button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add, color: Color(0xFF4D4AE8)),
                  label: const Text(
                    'Also Add Cash',
                    style: TextStyle(
                      color: Color(0xFF4D4AE8),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    backgroundColor: const Color(0xFFF4F6F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _isProcessing ? null : _handleSplitPayment,
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

  const _PaymentMethodButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: OutlinedButton(
          onPressed: onTap,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: isSelected ? const Color(0xFFEEF2FF) : const Color(0xFFF4F6F8),
            side: BorderSide(
              color: isSelected ? const Color(0xFF4D4AE8) : const Color(0xFFE5E7EB),
              width: isSelected ? 2 : 1,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF4D4AE8) : const Color(0xFF1F2937),
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                  color: isSelected ? const Color(0xFF4D4AE8) : const Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
