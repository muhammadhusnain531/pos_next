import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:posnext/services/database_service.dart';

class ReceiptService {
  
  /// Generate a PDF Document for the receipt
  Future<pw.Document> generateReceipt({
    required Sale sale,
    required List<SaleItem> items,
    required List<Product> products,
    required Branche branch,
    User? user,
    String? customerName,
  }) async {
    final pdf = pw.Document();
    // Use Helvetica for a cleaner look as per image, or keep Courier if strictly needed. 
    // The image looks like a standard thermal printer font which is often sans-serif or monospaced.
    // Helvetica is a good safe default for "clean" text.
    final font = pw.Font.helvetica(); 
    final boldFont = pw.Font.helveticaBold();

    // Define page format (Roll 80mm)
    final pageFormat = PdfPageFormat(
      80 * PdfPageFormat.mm, 
      double.infinity, 
      marginAll: 5 * PdfPageFormat.mm
    );

    final dateFormat = DateFormat('dd-MMM-yyyy hh:mm:ss a');

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // --- Header ---
              pw.Center(child: pw.Text('Purchase Slip', style: pw.TextStyle(font: font, fontSize: 10))),
              pw.SizedBox(height: 5),
              pw.Center(child: pw.Text(branch.name, style: pw.TextStyle(font: boldFont, fontSize: 14), textAlign: pw.TextAlign.center)),
              if (branch.address != null)
                pw.Center(child: pw.Text(branch.address!, style: pw.TextStyle(font: font, fontSize: 10), textAlign: pw.TextAlign.center)),
              if (branch.contact != null)
                pw.Center(child: pw.Text(branch.contact!, style: pw.TextStyle(font: font, fontSize: 10))),
              
              pw.SizedBox(height: 10),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Pos: 002', style: pw.TextStyle(font: font, fontSize: 10)), // Static or from device ID
                  pw.Text('Mop: ${sale.paymentMethod}', style: pw.TextStyle(font: font, fontSize: 10)),
                ]
              ),
              
              pw.SizedBox(height: 5),
              pw.Text('Receipt #: ${sale.invoiceNumber}', style: pw.TextStyle(font: font, fontSize: 10)),
              pw.Text('Date: ${dateFormat.format(sale.date)}', style: pw.TextStyle(font: font, fontSize: 10)),
              if (customerName != null && customerName.isNotEmpty)
                pw.Text('Customer Name: $customerName', style: pw.TextStyle(font: font, fontSize: 10)),
              
              pw.SizedBox(height: 5),
              
              // --- Items Table ---
              _buildDottedLine(),
              pw.Row(
                children: [
                  pw.Expanded(flex: 1, child: pw.Text('Sr.', style: pw.TextStyle(font: boldFont, fontSize: 10))),
                  pw.Expanded(flex: 6, child: pw.Text('Product', style: pw.TextStyle(font: boldFont, fontSize: 10))),
                  pw.Expanded(flex: 2, child: pw.Text('Price', style: pw.TextStyle(font: boldFont, fontSize: 10), textAlign: pw.TextAlign.right)),
                  pw.Expanded(flex: 2, child: pw.Text('Qty', style: pw.TextStyle(font: boldFont, fontSize: 10), textAlign: pw.TextAlign.right)),
                  pw.Expanded(flex: 3, child: pw.Text('Total', style: pw.TextStyle(font: boldFont, fontSize: 10), textAlign: pw.TextAlign.right)),
                ]
              ),
              _buildDottedLine(),
              
              ...items.asMap().entries.map((entry) {
                final index = entry.key + 1;
                final item = entry.value;
                final product = products.firstWhere(
                  (p) => p.id == item.productId,
                  orElse: () => Product(
                    id: -1, 
                    branchId: 0, 
                    name: 'Unknown', 
                    barcode: '', 
                    quantity: 0, 
                    price: 0,
                    status: ''
                  ),
                );
                
                return pw.Container(
                  margin: const pw.EdgeInsets.symmetric(vertical: 2),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(flex: 1, child: pw.Text('$index', style: pw.TextStyle(font: font, fontSize: 10))),
                      pw.Expanded(flex: 6, child: pw.Text(product.name, style: pw.TextStyle(font: font, fontSize: 10))),
                      pw.Expanded(flex: 2, child: pw.Text(item.price.toStringAsFixed(2), style: pw.TextStyle(font: font, fontSize: 10), textAlign: pw.TextAlign.right)),
                      pw.Expanded(flex: 2, child: pw.Text(item.quantity.toStringAsFixed(2), style: pw.TextStyle(font: font, fontSize: 10), textAlign: pw.TextAlign.right)),
                      pw.Expanded(flex: 3, child: pw.Text((item.price * item.quantity).toStringAsFixed(2), style: pw.TextStyle(font: font, fontSize: 10), textAlign: pw.TextAlign.right)),
                    ]
                  )
                );
              }).toList(),
              
              _buildDottedLine(),
              
              // --- Totals ---
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text('Gross Total:', style: pw.TextStyle(font: font, fontSize: 10)),
                  pw.SizedBox(width: 20),
                  pw.Text(sale.totalAmount.toStringAsFixed(2), style: pw.TextStyle(font: font, fontSize: 10)),
                ]
              ),
              if (sale.discount > 0)
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Discount:', style: pw.TextStyle(font: font, fontSize: 10)),
                    pw.SizedBox(width: 20),
                    pw.Text(sale.discount.toStringAsFixed(2), style: pw.TextStyle(font: font, fontSize: 10)),
                  ]
                ),
               pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Text('Net Total:', style: pw.TextStyle(font: boldFont, fontSize: 12)),
                    pw.SizedBox(width: 20),
                    pw.Text((sale.totalAmount - sale.discount).toStringAsFixed(2), style: pw.TextStyle(font: boldFont, fontSize: 12)),
                  ]
                ),
              
              pw.SizedBox(height: 10),
              
              // --- Footer ---
              if (user != null)
                pw.Text('Sales Person: ${user.name ?? user.username}', style: pw.TextStyle(font: font, fontSize: 10)),
              
              pw.SizedBox(height: 5),
              pw.Text('Dear Valuable Customer,', style: pw.TextStyle(font: font, fontSize: 10)),
              pw.Bullet(text: 'Price inclusive of sales tax if any', style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Bullet(text: 'Please check and verify your medicine, consumer, health care products, expiry dates and balance cash before leaving the counter, any later claim will not be acceptable.', style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Bullet(text: 'Consumer and nutraceutical products are non-refundable and can only be changed.', style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Bullet(text: 'Fridge items, cutting medicines, loose tablets/capsules, inhalers, sprays, appliances, test strips and baby milk are neither returnable nor exchangeable.', style: pw.TextStyle(font: font, fontSize: 9)),
              pw.Bullet(text: 'Items can be returned only with original invoice within 7 days.', style: pw.TextStyle(font: font, fontSize: 9)),
              
              pw.SizedBox(height: 15),
              pw.Center(child: pw.Text('Thank you for visit', style: pw.TextStyle(font: font, fontSize: 10))),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  pw.Widget _buildDottedLine() {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 5),
      child: pw.Divider(borderStyle: pw.BorderStyle.dotted, thickness: 0.5),
    );
  }
}
