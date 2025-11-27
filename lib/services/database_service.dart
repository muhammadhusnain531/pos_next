import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'database_service.g.dart';

// Companies Table (Super Admin Level)
class Companies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get address => text().nullable()();
  TextColumn get contact => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Branches Table (Company Level)
class Branches extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get companyId => integer().references(Companies, #id)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get address => text().nullable()();
  TextColumn get contact => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Users Table (Role Based Access)
class Users extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer().nullable().references(Branches, #id)(); // Nullable for SuperAdmin
  TextColumn get username => text().unique()();
  TextColumn get password => text()(); // Hashed
  TextColumn get role => text()(); // 'SuperAdmin', 'BranchAdmin', 'User'
  TextColumn get name => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
}

// Products Table
class Products extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer().references(Branches, #id)(); // Stock is per branch
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get barcode => text().withLength(min: 1, max: 50)(); 
  TextColumn get category => text().nullable()();
  IntColumn get quantity => integer().withDefault(const Constant(0))();
  RealColumn get price => real()();
  TextColumn get sku => text().nullable()();
  TextColumn get status => text().withDefault(const Constant('In Stock'))();
}

// Sales Table
class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer().references(Branches, #id)();
  IntColumn get userId => integer().nullable().references(Users, #id)();
  TextColumn get invoiceNumber => text()();
  RealColumn get totalAmount => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  TextColumn get paymentMethod => text()(); 
  DateTimeColumn get date => dateTime().withDefault(currentDateAndTime)();
}

// Sale Items Table (for line items)
class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get productId => integer().references(Products, #id)();
  IntColumn get quantity => integer()();
  RealColumn get price => real()(); 
}

// Business Days Table
class BusinessDays extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer().references(Branches, #id)();
  DateTimeColumn get openTime => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get closeTime => dateTime().nullable()();
  RealColumn get openingBalance => real()();
  RealColumn get closingBalance => real().nullable()();
  RealColumn get totalCashSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalCardSales => real().withDefault(const Constant(0.0))();
  RealColumn get totalGiftCardSales => real().withDefault(const Constant(0.0))(); 
  RealColumn get totalOtherSales => real().withDefault(const Constant(0.0))(); 
  TextColumn get status => text().withDefault(const Constant('Open'))(); 
  TextColumn get openedBy => text().nullable()();
  TextColumn get closedBy => text().nullable()();
  RealColumn get discrepancy => real().nullable()();
}

@DriftDatabase(tables: [Products, Sales, SaleItems, BusinessDays, Companies, Branches, Users])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 4; // Incremented to 4

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
        if (from < 4) {
          // Create new tables
          await m.createTable(companies);
          await m.createTable(branches);
          await m.createTable(users);

          // Add columns to existing tables
          await m.addColumn(products, products.branchId);
          await m.addColumn(sales, sales.branchId);
          await m.addColumn(sales, sales.userId);
          await m.addColumn(businessDays, businessDays.branchId);
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
  Future<int> openBusinessDay(int branchId, double openingBalance, String? user) {
    return into(businessDays).insert(BusinessDaysCompanion(
      branchId: Value(branchId),
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

  // --- Auth Queries ---
  Future<bool> hasAnyUser() async {
    final user = await (select(users)..limit(1)).getSingleOrNull();
    return user != null;
  }

  Future<int> createSuperAdmin(String username, String password) {
    return into(users).insert(UsersCompanion(
      username: Value(username),
      password: Value(password), // In real app, hash this!
      role: Value('SuperAdmin'),
      isActive: Value(true),
    ));
  }

  // --- Admin Queries ---
  Future<List<Branche>> getAllBranches() => select(branches).get();
  
  Future<List<User>> getAllUsers() => select(users).get();

  Future<void> createBranchWithAdmin({
    required String branchName,
    required String branchAddress,
    required String adminUsername,
    required String adminPassword,
  }) {
    return transaction(() async {
      // 1. Create Company if not exists (Simplified: assuming single company for now)
      // For now, we'll just create a dummy company if table is empty
      final companiesList = await select(companies).get();
      int companyId;
      if (companiesList.isEmpty) {
        companyId = await into(companies).insert(CompaniesCompanion(
          name: Value('Main Company'),
          address: Value('Headquarters'),
        ));
      } else {
        companyId = companiesList.first.id;
      }

      // 2. Create Branch
      final branchId = await into(branches).insert(BranchesCompanion(
        companyId: Value(companyId),
        name: Value(branchName),
        address: Value(branchAddress),
      ));

      // 3. Create Branch Admin
      await into(users).insert(UsersCompanion(
        branchId: Value(branchId),
        username: Value(adminUsername),
        password: Value(adminPassword),
        role: Value('BranchAdmin'),
        isActive: Value(true),
      ));
    });
  }

  Future<int> createUser(UsersCompanion user) => into(users).insert(user);
}
