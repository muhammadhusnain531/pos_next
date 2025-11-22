import 'package:flutter/material.dart';

class PayByCashPage extends StatefulWidget {
  final double totalDue;

  // Defaulting to 85.50 if not passed, just for demo consistency
  const PayByCashPage({Key? key, this.totalDue = 85.50}) : super(key: key);

  @override
  State<PayByCashPage> createState() => _PayByCashPageState();
}

class _PayByCashPageState extends State<PayByCashPage> {
  String _inputAmount = "";

  double get cashReceived => double.tryParse(_inputAmount) ?? 0.0;
  double get changeDue {
    double due = cashReceived - widget.totalDue;
    return due < 0 ? 0.0 : due;
  }

  void _onKeypadTap(String value) {
    setState(() {
      if (value == 'C') {
        // Clear input
        _inputAmount = "";
      } else if (value == 'BACKSPACE') {
        // Backspace
        if (_inputAmount.isNotEmpty) {
          _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        }
      } else if (value == 'ENTER') {
        _handleFinalize();
      } else {
        // Handle digits and decimal
        if (value == '.' && _inputAmount.contains('.')) return;
        // Prevent excessive length
        if (_inputAmount.length > 9) return;
        // Handle leading zero if needed, but simple string concat works fine for basic POS
        _inputAmount += value;
      }
    });
  }

  void _handleFinalize() {
    if (cashReceived >= widget.totalDue) {
      // Success
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Payment Successful"),
          content: Text("Change Due: \$${changeDue.toStringAsFixed(2)}"),
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
    } else {
      // Insufficient funds
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              "Insufficient Cash. Need \$${(widget.totalDue - cashReceived).toStringAsFixed(2)} more."),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                    'Pay by Cash',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        'Order #12345',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Table 5',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Total Due
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F6FE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: Color(0xFF3578F6), width: 4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Due',
                      style: TextStyle(
                        color: Color(0xFF3578F6),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$${widget.totalDue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF3578F6),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Cash Received
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cash Received',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F6F8),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      _inputAmount.isEmpty ? "0.00" : _inputAmount,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Keypad
              _CustomKeypad(onTap: _onKeypadTap),
              const SizedBox(height: 24),
              // Change Due
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAFBF0),
                  borderRadius: BorderRadius.circular(8),
                  border: Border(left: BorderSide(color: Color(0xFF20B15A), width: 4)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Change Due',
                      style: TextStyle(
                        color: Color(0xFF20B15A),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$${changeDue.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Color(0xFF20B15A),
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Footer Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back, color: Colors.grey),
                      label: const Text(
                        'Back to Payment',
                        style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _handleFinalize,
                      icon: const Icon(Icons.receipt_long),
                      label: const Text(
                        'Finalize & Print\nReceipt',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF20B15A),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomKeypad extends StatelessWidget {
  final Function(String) onTap;

  const _CustomKeypad({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxDecoration(
      color: const Color(0xFFF4F6F8),
      borderRadius: BorderRadius.circular(10),
    );
    final textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);

    Widget buildButton(String value, {String? label, Color? bgColor, Color? fgColor, IconData? icon}) {
      return Expanded(
        child: GestureDetector(
          onTap: () => onTap(value),
          child: Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor ?? const Color(0xFFF4F6F8),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 56,
            child: Center(
              child: icon == null
                  ? Text(
                      label ?? value,
                      style: textStyle.copyWith(color: fgColor ?? Colors.black),
                    )
                  : Icon(icon, color: fgColor ?? Colors.black, size: 26),
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          children: [
            buildButton('7'),
            buildButton('8'),
            buildButton('9'),
            buildButton('BACKSPACE', bgColor: const Color(0xFFFEE4E2), icon: Icons.backspace_outlined, fgColor: Colors.red),
          ],
        ),
        Row(
          children: [
            buildButton('4'),
            buildButton('5'),
            buildButton('6'),
            buildButton('C', bgColor: const Color(0xFFF4F6F8)),
          ],
        ),
        Row(
          children: [
            buildButton('1'),
            buildButton('2'),
            buildButton('3'),
            buildButton('ENTER', bgColor: const Color(0xFF3578F6), icon: Icons.check, fgColor: Colors.white),
          ],
        ),
        Row(
          children: [
            const Spacer(),
            buildButton('0'),
            buildButton('.'),
            const Spacer(),
          ],
        ),
      ],
    );
  }
}
