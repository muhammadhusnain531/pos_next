import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'database_service.g.dart';

// Products Table
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get barcode => text().withLength(min: 1, max: 50)(); // Scan this
  TextColumn get category => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  RealColumn get price => real()();
  TextColumn get sku => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('In Stock'))();
}

// Sales Table
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get invoiceNumber => text()();
  RealColumn get totalAmount => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text()(); // Cash, Card, etc.
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}

// Sale Items Table (for line items)
class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()(); // Snapshot price at time of sale
}

// Business Days Table
class BusinessDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get openTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closeTime => dateTime().nullable()();
  RealColumn get openingBalance => real()();
  RealColumn get closingBalance => real().nullable()();
  RealColumn get totalCashSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalCardSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalGiftCardSales => real().withDefault(const Constant(0.0))(); // New
  RealColumn get totalOtherSales => real().withDefault(const Constant(0.0))(); // New
  TextColumn get status => text().withDefault(const Constant('Open'))(); // Open, Closed
  TextColumn get openedBy => text().nullable()();
  TextColumn get closedBy => text().nullable()();
  RealColumn get discrepancy => real().nullable()();
}

@DriftDatabase(tables: [Products, Sales, SaleItems, BusinessDays])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 3; // Incremented to 3

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from < 2) {
          await m.createTable(businessDays);
        }
        if (from < 3) {
          await m.addColumn(businessDays, businessDays.totalGiftCardSales);
          await m.addColumn(businessDays, businessDays.totalOtherSales);
        }
      },
    );
  }

  // --- Product Queries ---
  Future<List<Product>> getAllProducts() => select(products).get();
  
  Future<Product?> getProductByBarcode(String code) {
    return (select(products)..where((tbl) => tbl.barcode.equals(code))).getSingleOrNull();
  }

  // Search for POS: Matches exact barcode OR partial name
  Future<List<Product>> searchProducts(String query) {
    return (select(products)..where((t) => t.barcode.equals(query) | t.name.like('%$query%'))).get();
  }

  Future<int> addProduct(ProductsCompanion entry) => into(products).insert(entry);
  
  Future<bool> updateProduct(Product entry) => update(products).replace(entry);
  
  Future<int> deleteProduct(int id) => (delete(products)..where((t) => t.id.equals(id))).go();


  // --- Sales Queries ---
  Future<int> createSale(SalesCompanion sale, List<SaleItemsCompanion> items) {
    return transaction(() async {
      
      for (final item in items) {
        // 1. Get current product
        final product = await (select(products)..where((t) => t.id.equals(item.productId.value))).getSingle();
        
        // Check stock availability
        if (product.quantity < item.quantity.value) {
          throw Exception("Insufficient stock for product: ${product.name}");
        }

        // 2. Calculate new quantity
        final newQty = product.quantity - item.quantity.value;
        
        // 3. Update status if OOS
        String newStatus = newQty <= 0 ? 'Out of Stock' : (newQty < 10 ? 'Low Stock' : 'In Stock');
        
        // 4. Update product
        await update(products).replace(product.copyWith(
          quantity: newQty,
          status: newStatus
        ));
      }

      final saleId = await into(sales).insert(sale);
      
      for (final item in items) {
        await into(saleItems).insert(
          item.copyWith(saleId: Value(saleId)),
        );
      }
      
      // Update current business day sales
      final currentDay = await getCurrentBusinessDay();
      if (currentDay != null) {
        double saleAmount = sale.totalAmount.value;
        final method = sale.paymentMethod.value;
        print("DEBUG: Updating Day ${currentDay.id} for Sale: $saleAmount via $method");

        if (method == 'Cash') {
          print("DEBUG: Incrementing Cash Sales");
          await (update(businessDays)..where((t) => t.id.equals(currentDay.id))).write(
            BusinessDaysCompanion(
              totalCashSales: Value(currentDay.totalCashSales + saleAmount),
            ),
          );
        } else if (method == 'Card') {
          print("DEBUG: Incrementing Card Sales");
          await (update(businessDays)..where((t) => t.id.equals(currentDay.id))).write(
            BusinessDaysCompanion(
              totalCardSales: Value(currentDay.totalCardSales + saleAmount),
            ),
          );
        } else if (method == 'Gift Card') {
           await (update(businessDays)..where((t) => t.id.equals(currentDay.id))).write(
            BusinessDaysCompanion(
              totalGiftCardSales: Value(currentDay.totalGiftCardSales + saleAmount),
            ),
          );
        } else {
           await (update(businessDays)..where((t) => t.id.equals(currentDay.id))).write(
            BusinessDaysCompanion(
              totalOtherSales: Value(currentDay.totalOtherSales + saleAmount),
            ),
          );
        }
      }
      
      return saleId;
    });
  }

  Future<List<Sale>> getAllSales() => select(sales).get();
  
  // Report Query: Get sales between dates
  Future<List<Sale>> getSalesByDateRange(DateTime start, DateTime end) {
    return (select(sales)..where((tbl) => tbl.date.isBetweenValues(start, end))).get();
  }

  // --- Business Day Queries ---
  Future<int> openBusinessDay(double openingBalance, String? user) {
    return into(businessDays).insert(BusinessDaysCompanion(
      openingBalance: Value(openingBalance),
      openedBy: Value(user),
      status: Value('Open'),
      openTime: Value(DateTime.now()),
    ));
  }

  Future<int> closeBusinessDay(int id, double closingBalance, double discrepancy, String? user) {
    return (update(businessDays)..where((t) => t.id.equals(id))).write(BusinessDaysCompanion(
      closingBalance: Value(closingBalance),
      discrepancy: Value(discrepancy),
      closedBy: Value(user),
      status: Value('Closed'),
      closeTime: Value(DateTime.now()),
    ));
  }

  Future<BusinessDay?> getCurrentBusinessDay() {
    return (select(businessDays)
      ..where((t) => t.status.equals('Open'))
      ..orderBy([(t) => OrderingTerm.desc(t.openTime)])
      ..limit(1)
    ).getSingleOrNull();
  }
}
