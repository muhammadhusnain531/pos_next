import 'package:flutter/material.dart';

class PayByCardPage extends StatelessWidget {
  const PayByCardPage({Key? key}) : super(key: key);

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
                        'Date: 24/05/2024',
                        style: TextStyle(
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
                  enabled: false,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                  decoration: InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    hintText: '55.00',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  ),
                  _PaymentMethodButton(
                    icon: Icons.account_balance,
                    label: 'Meezan',
                  ),
                  _PaymentMethodButton(
                    icon: Icons.account_balance,
                    label: 'ABL',
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
                  ),
                  _PaymentMethodButton(
                    icon: Icons.credit_card,
                    label: 'Debit Card',
                  ),
                  _PaymentMethodButton(
                    icon: Icons.qr_code_2,
                    label: 'QR Code',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              // Proceed to Pay button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.payment, color: Colors.white),
                  label: const Text(
                    'Proceed to Pay',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF4D4AE8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
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
                    side: BorderSide(color: Color(0xFFE5E7EB)),
                    backgroundColor: Color(0xFFF4F6F8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {},
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

  const _PaymentMethodButton({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
            backgroundColor: const Color(0xFFF4F6F8),
            side: const BorderSide(color: Color(0xFFE5E7EB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: Color(0xFF1F2937),
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}