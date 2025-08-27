import 'package:flutter/material.dart';


class PayByCashPage extends StatelessWidget {
  const PayByCashPage({Key? key}) : super(key: key);

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
                  children: const [
                    Text(
                      'Total Due',
                      style: TextStyle(
                        color: Color(0xFF3578F6),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$85.50',
                      style: TextStyle(
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
                    ),
                    child: const Text(
                      '100.00',
                      style: TextStyle(
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
              _CustomKeypad(),
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
                  children: const [
                    Text(
                      'Change Due',
                      style: TextStyle(
                        color: Color(0xFF20B15A),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '\$14.50',
                      style: TextStyle(
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
                      onPressed: () {},
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
                      onPressed: () {},
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
  const _CustomKeypad({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonStyle = BoxDecoration(
      color: const Color(0xFFF4F6F8),
      borderRadius: BorderRadius.circular(10),
    );
    final textStyle = const TextStyle(fontSize: 24, fontWeight: FontWeight.w600);

    Widget buildButton(String text, {Color? bgColor, Color? fgColor, IconData? icon}) {
      return Expanded(
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
              text,
              style: textStyle.copyWith(color: fgColor ?? Colors.black),
            )
                : Icon(icon, color: fgColor ?? Colors.black, size: 26),
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
            buildButton('', bgColor: const Color(0xFFFEE4E2), icon: Icons.close, fgColor: Colors.red),
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
            buildButton('', bgColor: const Color(0xFF3578F6), icon: Icons.check, fgColor: Colors.white),
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