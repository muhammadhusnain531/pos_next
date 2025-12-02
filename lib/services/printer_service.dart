import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PrinterService {
  
  /// Print a PDF document directly
  Future<void> printReceipt(pw.Document pdf) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Receipt',
    );
  }

  /// Get list of available printers (optional, for direct printing)
  Future<List<Printer>> getPrinters() async {
    return await Printing.listPrinters();
  }

  /// Direct print to a specific printer (if needed)
  Future<void> printDirect(Printer printer, pw.Document pdf) async {
    await Printing.directPrintPdf(
      printer: printer,
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
