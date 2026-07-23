import 'package:drift/drift.dart';
import 'connection/connection.dart';

part 'database_service.g.dart';
// import 'dart:io'; // Removed for web compatibility
// import 'package:file_picker/file_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;

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
  BoolColumn get isService => boolean().withDefault(const Constant(false))();
  IntColumn get durationMinutes => integer().nullable()();
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

// Customers Table
class Customers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get phone => text().withLength(min: 1, max: 50)();
  TextColumn get email => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Staff Table (Stylists / Beauticians)
class Staff extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer().references(Branches, #id)();
  TextColumn get name => text().withLength(min: 1, max: 255)();
  TextColumn get phone => text().nullable()();
  TextColumn get specialty => text().nullable()();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Appointments Table (Advance Bookings)
class Appointments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get branchId => integer().references(Branches, #id)();
  IntColumn get customerId => integer().references(Customers, #id)();
  IntColumn get serviceId => integer().references(Products, #id)();
  IntColumn get staffId => integer().nullable().references(Staff, #id)();
  DateTimeColumn get appointmentTime => dateTime()();
  IntColumn get durationMinutes => integer().withDefault(const Constant(30))();
  TextColumn get status => text().withDefault(const Constant('Pending'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [Products, Sales, SaleItems, BusinessDays, Companies, Branches, Users, Customers, Staff, Appointments])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(openConnection());

  @override
  int get schemaVersion => 5; // Incremented to 5

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
        if (from < 5) {
          // Create new salon tables
          await m.createTable(customers);
          await m.createTable(staff);
          await m.createTable(appointments);

          // Add new columns to products
          await m.addColumn(products, products.isService);
          await m.addColumn(products, products.durationMinutes);
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
        
        if (product.isService) {
          continue; // Services do not use stock inventory
        }
        
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
      final currentDay = await getCurrentBusinessDay(sale.branchId.value);
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
  Future<List<Sale>> getSalesByDateRange(int branchId, DateTime start, DateTime end) {
    return (select(sales)
      ..where((tbl) => tbl.branchId.equals(branchId) & tbl.date.isBetweenValues(start, end))
    ).get();
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

  Future<BusinessDay?> getCurrentBusinessDay(int branchId) {
    return (select(businessDays)
      ..where((t) => t.branchId.equals(branchId) & t.status.equals('Open'))
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

  // --- Customer Queries ---
  Future<List<Customer>> getAllCustomers() => select(customers).get();
  Future<int> createCustomer(CustomersCompanion entry) => into(customers).insert(entry);
  Future<bool> updateCustomer(Customer entry) => update(customers).replace(entry);
  Future<int> deleteCustomer(int id) => (delete(customers)..where((t) => t.id.equals(id))).go();

  // --- Staff Queries ---
  Future<List<StaffData>> getAllStaff(int branchId) {
    return (select(staff)..where((tbl) => tbl.branchId.equals(branchId))).get();
  }
  Future<int> createStaff(StaffCompanion entry) => into(staff).insert(entry);
  Future<bool> updateStaff(StaffData entry) => update(staff).replace(entry);
  Future<int> deleteStaff(int id) => (delete(staff)..where((t) => t.id.equals(id))).go();

  // --- Appointment Queries ---
  Future<List<Appointment>> getAllAppointments(int branchId) {
    return (select(appointments)..where((tbl) => tbl.branchId.equals(branchId))).get();
  }
  Future<List<Appointment>> getAppointmentsForDate(int branchId, DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = DateTime(date.year, date.month, date.day, 23, 59, 59);
    return (select(appointments)
      ..where((tbl) => tbl.branchId.equals(branchId) & tbl.appointmentTime.isBetweenValues(start, end))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.appointmentTime)])
    ).get();
  }
  Future<int> createAppointment(AppointmentsCompanion entry) => into(appointments).insert(entry);
  Future<bool> updateAppointment(Appointment entry) => update(appointments).replace(entry);
  Future<int> deleteAppointment(int id) => (delete(appointments)..where((t) => t.id.equals(id))).go();

  Future<void> seedDemoData() async {
    return transaction(() async {
      // 1. Ensure a Branch exists (or create one)
      final branchesList = await select(branches).get();
      int branchId;
      if (branchesList.isEmpty) {
        // Create Company
        final companyId = await into(companies).insert(CompaniesCompanion(
          name: const Value('Vibrant Nails & Hair Salon'),
          address: const Value('102 Beauty Avenue, New York'),
        ));
        branchId = await into(branches).insert(BranchesCompanion(
          companyId: Value(companyId),
          name: const Value('Main Salon Branch'),
          address: const Value('102 Beauty Avenue, New York'),
        ));
      } else {
        branchId = branchesList.first.id;
      }

      // 2. Ensure SuperAdmin exists
      final usersList = await select(users).get();
      if (usersList.isEmpty) {
        await into(users).insert(UsersCompanion(
          branchId: Value(branchId),
          username: const Value('admin'),
          password: const Value('admin'),
          role: const Value('SuperAdmin'),
          isActive: const Value(true),
          name: const Value('Salon Admin'),
        ));
      }

      // 3. Insert Demo Customers
      final customerIds = <int>[];
      final currentCustomers = await select(customers).get();
      if (currentCustomers.isEmpty) {
        customerIds.add(await into(customers).insert(const CustomersCompanion(
          name: Value('Emily Watson'),
          phone: Value('+92 300 9876543'),
          email: Value('emily@example.com'),
        )));
        customerIds.add(await into(customers).insert(const CustomersCompanion(
          name: Value('Michael Green'),
          phone: Value('+92 321 5551234'),
          email: Value('michael@example.com'),
        )));
        customerIds.add(await into(customers).insert(const CustomersCompanion(
          name: Value('Sophia Taylor'),
          phone: Value('+92 312 7776655'),
          email: Value('sophia@example.com'),
        )));
      } else {
        customerIds.addAll(currentCustomers.map((c) => c.id));
      }

      // 4. Insert Demo Staff / Stylists
      final staffIds = <int>[];
      final currentStaff = await select(staff).get();
      if (currentStaff.isEmpty) {
        staffIds.add(await into(staff).insert(StaffCompanion(
          branchId: Value(branchId),
          name: const Value('Jessica Alva'),
          specialty: const Value('Hair Coloring'),
          isActive: const Value(true),
        )));
        staffIds.add(await into(staff).insert(StaffCompanion(
          branchId: Value(branchId),
          name: const Value('David Beckham'),
          specialty: const Value('Classic Cuts'),
          isActive: const Value(true),
        )));
        staffIds.add(await into(staff).insert(StaffCompanion(
          branchId: Value(branchId),
          name: const Value('Sarah Jessica'),
          specialty: const Value('Nails & Manicure'),
          isActive: const Value(true),
        )));
      } else {
        staffIds.addAll(currentStaff.map((s) => s.id));
      }

      // 5. Insert Demo Products and Services
      final serviceIds = <int>[];
      final currentProducts = await select(products).get();
      if (currentProducts.isEmpty) {
        // Retail Products
        await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Nourishing Salon Shampoo'),
          barcode: const Value('1001'),
          category: const Value('Hair Care'),
          quantity: const Value(50),
          price: const Value(15.00),
          isService: const Value(false),
        ));
        await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Hydrating Conditioner'),
          barcode: const Value('1002'),
          category: const Value('Hair Care'),
          quantity: const Value(40),
          price: const Value(18.00),
          isService: const Value(false),
        ));
        await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Matte Clay Hair Wax'),
          barcode: const Value('1003'),
          category: const Value('Styling'),
          quantity: const Value(30),
          price: const Value(12.00),
          isService: const Value(false),
        ));

        // Services
        serviceIds.add(await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Classic Scissors Haircut'),
          barcode: const Value('2001'),
          category: const Value('Services'),
          quantity: const Value(0),
          price: const Value(25.00),
          isService: const Value(true),
          durationMinutes: const Value(30),
        )));
        serviceIds.add(await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Full Hair Coloring & Styling'),
          barcode: const Value('2002'),
          category: const Value('Services'),
          quantity: const Value(0),
          price: const Value(75.00),
          isService: const Value(true),
          durationMinutes: const Value(90),
        )));
        serviceIds.add(await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Deluxe Manicure & Pedicure'),
          barcode: const Value('2003'),
          category: const Value('Services'),
          quantity: const Value(0),
          price: const Value(40.00),
          isService: const Value(true),
          durationMinutes: const Value(60),
        )));
        serviceIds.add(await into(products).insert(ProductsCompanion(
          branchId: Value(branchId),
          name: const Value('Organic Hydrating Facial'),
          barcode: const Value('2004'),
          category: const Value('Services'),
          quantity: const Value(0),
          price: const Value(50.00),
          isService: const Value(true),
          durationMinutes: const Value(45),
        )));
      } else {
        serviceIds.addAll(currentProducts.where((p) => p.isService).map((p) => p.id));
      }

      // 6. Insert Demo Appointments (for today)
      final currentAppts = await select(appointments).get();
      if (currentAppts.isEmpty && customerIds.isNotEmpty && staffIds.isNotEmpty && serviceIds.isNotEmpty) {
        final now = DateTime.now();

        // 1st Appointment: Completed (ready for checkout)
        await into(appointments).insert(AppointmentsCompanion(
          branchId: Value(branchId),
          customerId: Value(customerIds[0]), // Emily
          serviceId: Value(serviceIds[1]), // Hair Coloring
          staffId: Value(staffIds[0]), // Jessica
          appointmentTime: Value(DateTime(now.year, now.month, now.day, 10, 0)),
          durationMinutes: const Value(90),
          status: const Value('Completed'),
          notes: const Value('Wants honey blonde highlights'),
        ));

        // 2nd Appointment: Confirmed
        await into(appointments).insert(AppointmentsCompanion(
          branchId: Value(branchId),
          customerId: Value(customerIds[1]), // Michael
          serviceId: Value(serviceIds[0]), // Classic Haircut
          staffId: Value(staffIds[1]), // David
          appointmentTime: Value(DateTime(now.year, now.month, now.day, 13, 30)),
          durationMinutes: const Value(30),
          status: const Value('Confirmed'),
          notes: const Value('Regular trim'),
        ));

        // 3rd Appointment: Pending
        await into(appointments).insert(AppointmentsCompanion(
          branchId: Value(branchId),
          customerId: Value(customerIds[2]), // Sophia
          serviceId: Value(serviceIds[2]), // Manicure/Pedicure
          staffId: Value(staffIds[2]), // Sarah
          appointmentTime: Value(DateTime(now.year, now.month, now.day, 15, 0)),
          durationMinutes: const Value(60),
          status: const Value('Pending'),
          notes: const Value('Prefers red nail polish'),
        ));
      }
    });
  }

  // --- Backup & Restore ---
  Future<void> backupDatabase() => performBackup();

  Future<void> restoreDatabase() => performRestore();
}
