import 'package:flutter/material.dart';
import 'package:posnext/screens/main_screen.dart';

import 'addproductscreen.dart';
import 'customerdetailsscreen.dart';
import 'giftcardscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainSaleScreen(),
    );
  }
}







/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';

// Import theme
import 'theme/app_theme.dart';
import 'theme/colors.dart';

// Import providers (will be created later)
import 'providers/cart_provider.dart';
import 'providers/product_provider.dart';
import 'providers/sales_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/barcode_provider.dart';

// Import screens
import 'screens/main_sale_screen.dart';
import 'screens/payment_screens/cash_payment_screen.dart';
import 'screens/payment_screens/card_payment_screen.dart';
import 'screens/payment_screens/gift_card_screen.dart';
import 'screens/product_screens/add_product_screen.dart';
import 'screens/product_screens/product_list_screen.dart';
import 'screens/product_screens/stock_details_screen.dart';
import 'screens/transaction_screens/receipt_screen.dart';
import 'screens/transaction_screens/return_screen.dart';
import 'screens/transaction_screens/void_product_screen.dart';
import 'screens/transaction_screens/void_payment_screen.dart';
import 'screens/business_screens/daily_summary_screen.dart';
import 'screens/business_screens/reports_screen.dart';
import 'screens/business_screens/day_opening_screen.dart';
import 'screens/business_screens/day_closing_screen.dart';
import 'screens/customer_screens/customer_details_screen.dart';
import 'screens/customer_screens/customer_list_screen.dart';
import 'screens/discount_screens/discount_screen.dart';
import 'screens/discount_screens/issue_gift_card_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations (mainly for desktop/tablet)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
    DeviceOrientation.portraitUp,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const POSNextApp());
}

class POSNextApp extends StatelessWidget {
  const POSNextApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // State Management Providers
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => SalesProvider()),
        ChangeNotifierProvider(create: (_) => BarcodeProvider()),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return MaterialApp(
            // App Configuration
            title: 'POS Next',
            debugShowCheckedModeBanner: false,

            // Theme Configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: settingsProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,

            // Initial Route
            initialRoute: AppRoutes.home,

            // Route Configuration
            routes: _buildRoutes(),

            // Handle unknown routes
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => const MainSaleScreen(),
              );
            },

            // Global app configurations
            builder: (context, child) {
              return MediaQuery(
                // Prevent font scaling issues on different devices
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }

  // Define all application routes
  Map<String, WidgetBuilder> _buildRoutes() {
    return {
    // Main Screen
    AppRoutes.home: (context) => const MainSaleScreen(),

    // Payment Screens
    AppRoutes.cashPayment: (context) => const CashPaymentScreen(),
    AppRoutes.cardPayment: (context) => const CardPaymentScreen(),
    AppRoutes.giftCard: (context) => const GiftCardScreen(),

    // Product Management Screens
    AppRoutes.addProduct: (context) => const AddProductScreen(),
    AppRoutes.productList: (context) => const ProductListScreen(),
    AppRoutes.stockDetails: (context) => const StockDetailsScreen(),

    // Transaction Screens
    AppRoutes.receipt: (context) => const ReceiptScreen(),
    AppRoutes.return: (context) => const ReturnScreen(),
    AppRoutes.voidProduct: (context) => const VoidProductScreen(),
    AppRoutes.voidPayment: (context) => const VoidPaymentScreen(),

    // Business Operation Screens
    AppRoutes.dailySummary: (context) => const DailySummaryScreen(),
    AppRoutes.reports: (context) => const ReportsScreen(),
    AppRoutes.dayOpening: (context) => const DayOpeningScreen(),
    AppRoutes.dayClosing: (context) => const DayClosingScreen(),

    // Customer Management Screens
    AppRoutes.customerDetails: (context) => const CustomerDetailsScreen(),
    AppRoutes.customerList: (context) => const CustomerListScreen(),

    // Discount Screens
    AppRoutes.discount: (context) => const DiscountScreen(),
    AppRoutes.issueGiftCard: (context) => const IssueGiftCardScreen(),

    // Settings Screen
    AppRoutes.settings: (context) => const SettingsScreen(),
  };
  }
}

// Application Routes Constants
class AppRoutes {
  // Main Screen
  static const String home = '/';

  // Payment Routes
  static const String cashPayment = '/cash-payment';
  static const String cardPayment = '/card-payment';
  static const String giftCard = '/gift-card';

  // Product Management Routes
  static const String addProduct = '/add-product';
  static const String productList = '/product-list';
  static const String stockDetails = '/stock-details';

  // Transaction Routes
  static const String receipt = '/receipt';
  static const String return = '/return';
  static const String voidProduct = '/void-product';
  static const String voidPayment = '/void-payment';

  // Business Operation Routes
  static const String dailySummary = '/daily-summary';
  static const String reports = '/reports';
  static const String dayOpening = '/day-opening';
  static const String dayClosing = '/day-closing';

  // Customer Management Routes
  static const String customerDetails = '/customer-details';
  static const String customerList = '/customer-list';

  // Discount Routes
  static const String discount = '/discount';
  static const String issueGiftCard = '/issue-gift-card';

  // Settings Route
  static const String settings = '/settings';
}

// App Configuration Class
class AppConfig {
  // App Information
  static const String appName = 'POS Next';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';

  // Business Configuration
  static const String defaultBusinessName = 'Your Business Name';
  static const String defaultCurrency = 'USD';
  static const String defaultCurrencySymbol = '\$';
  static const double defaultTaxRate = 0.08; // 8%

  // UI Configuration
  static const double defaultButtonHeight = 60.0;
  static const double defaultButtonWidth = 120.0;
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;

  // Performance Configuration
  static const int maxProductsInCart = 100;
  static const int maxDailyTransactions = 1000;
  static const int maxProductsInDatabase = 10000;

  // Print Configuration
  static const int receiptWidth = 58; // 58mm thermal paper
  static const String defaultReceiptHeader = 'Thank you for your purchase!';
  static const String defaultReceiptFooter = 'Visit us again!';

  // Barcode Configuration
  static const List<String> supportedBarcodeFormats = [
    'EAN13',
    'EAN8',
    'UPC-A',
    'UPC-E',
    'CODE128',
    'CODE39',
  ];

  // Database Configuration
  static const String databaseName = 'pos_next.db';
  static const int databaseVersion = 1;
}

// Global App Utilities
class AppUtils {
  // Navigation Helper
  static void navigateTo(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushNamed(context, routeName, arguments: arguments);
  }

  static void navigateAndReplace(BuildContext context, String routeName, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
  }

  static void navigateBack(BuildContext context) {
    Navigator.pop(context);
  }

  // Dialog Helper
  static void showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  static void showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Format Helpers
  static String formatCurrency(double amount) {
    return '${AppConfig.defaultCurrencySymbol}${amount.toStringAsFixed(2)}';
  }

  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}*/
