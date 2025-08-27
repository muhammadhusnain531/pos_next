import 'package:flutter/material.dart';

class HomeDeliveryPage extends StatelessWidget {
  const HomeDeliveryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: SizedBox(
            width: 1000,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text(
                    'Home Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Delivery Details and Order Items
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Delivery Details',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Delivery Address
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Delivery Address',
                              hintText: 'Start typing your address...',
                              suffixIcon: Icon(Icons.location_on_outlined),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Apartment
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Apartment, suite, etc. (optional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // City and Postal Code
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'City',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    labelText: 'Postal Code',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Contact Number
                          TextField(
                            decoration: InputDecoration(
                              labelText: 'Contact Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                          ),
                          const SizedBox(height: 32),
                          // Order Items
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Item 1
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Color(0xFFD4DED8),
                                  width: 56,
                                  height: 56,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?fit=crop&w=200&q=80',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Classic Leather Wallet',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'A timeless piece, crafted from genuine leather.',
                                      style: TextStyle(color: Colors.black54, fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Qty: 1',
                                      style: TextStyle(color: Colors.black45, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                '\$75.00',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Item 2
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  color: Color(0xFFE6EAD7),
                                  width: 56,
                                  height: 56,
                                  child: Image.network(
                                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?fit=crop&w=200&q=80',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Silk Scarf',
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      '100% pure silk, vibrant colors.',
                                      style: TextStyle(color: Colors.black54, fontSize: 14),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Qty: 2',
                                      style: TextStyle(color: Colors.black45, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                '\$90.00',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Right: Bill Details and Payment
                    const SizedBox(width: 32),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bill Details',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFFF4F6F8),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: [
                                _billDetailRow('Items Subtotal', '\$165.00'),
                                const SizedBox(height: 8),
                                _billDetailRow('Delivery Fee', '\$10.00'),
                                const SizedBox(height: 8),
                                _billDetailRow('Taxes (5%)', '\$8.25'),
                                const SizedBox(height: 8),
                                const Divider(),
                                _billDetailRow(
                                  'Total Amount',
                                  '\$183.25',
                                  isBold: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          const Text(
                            'Payment Method',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.local_shipping, color: Color(0xFF3578F6)),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text('Cash on Delivery', style: TextStyle(fontSize: 16)),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF3578F6), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.credit_card, color: Color(0xFF3578F6)),
                                  label: const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text('Online Payment', style: TextStyle(fontSize: 16)),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0xFF3578F6), width: 2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    backgroundColor: Color(0xFFF4F6F8),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                              label: const Text(
                                'Confirm Order - \$183.25',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF3578F6),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _billDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 16 : 15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            fontSize: isBold ? 18 : 15,
          ),
        ),
      ],
    );
  }
}