import 'package:flutter/material.dart';

class PayByCashPage extends StatefulWidget {
  final double totalDue;

  const PayByCashPage({Key? key, this.totalDue = 0.0}) : super(key: key);

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
        _inputAmount = "";
      } else if (value == 'BACKSPACE') {
        if (_inputAmount.isNotEmpty) {
          _inputAmount = _inputAmount.substring(0, _inputAmount.length - 1);
        }
      } else if (value == 'ENTER') {
        _handleFinalize();
      } else {
        if (value == '.' && _inputAmount.contains('.')) return;
        if (_inputAmount.length > 9) return;
        _inputAmount += value;
      }
    });
  }

  void _handleFinalize() {
    if (cashReceived >= widget.totalDue) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("Payment Successful"),
          content: Text("Change Due: Rs. ${changeDue.toStringAsFixed(2)}"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); 
                // Return TRUE to indicate successful payment
                Navigator.of(context).pop(true); 
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Insufficient Cash. Need Rs. ${(widget.totalDue - cashReceived).toStringAsFixed(2)} more."),
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
              BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 24, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Pay by Cash', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Text('Total Due: Rs. ${widget.totalDue.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Colors.blue)),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.grey[100],
                child: Text(
                  _inputAmount.isEmpty ? "0.00" : _inputAmount,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              _CustomKeypad(onTap: _onKeypadTap),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel"))),
                  Expanded(child: ElevatedButton(onPressed: _handleFinalize, child: const Text("Finalize"))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomKeypad extends StatelessWidget {
  final Function(String) onTap;
  const _CustomKeypad({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(['7', '8', '9', 'BACKSPACE']),
        const SizedBox(height: 8),
        _row(['4', '5', '6', 'C']),
        const SizedBox(height: 8),
        _row(['1', '2', '3', 'ENTER']),
        const SizedBox(height: 8),
        _row(['0', '.']),
      ],
    );
  }

  Widget _row(List<String> keys) {
    return Row(
      children: keys.map((k) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 20),
              backgroundColor: k == 'ENTER' ? Colors.blue : (k == 'BACKSPACE' ? Colors.red[100] : Colors.white),
              foregroundColor: k == 'ENTER' ? Colors.white : Colors.black,
            ),
            onPressed: () => onTap(k),
            child: k == 'BACKSPACE' ? const Icon(Icons.backspace, size: 18) : Text(k, style: const TextStyle(fontSize: 18)),
          ),
        ),
      )).toList(),
    );
  }
}
