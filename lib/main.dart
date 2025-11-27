import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/screens/main_screen.dart';
import 'package:posnext/services/auth_service.dart';
import 'package:posnext/screens/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Database
  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService(database)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'POS Next',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const LoginScreen(),
    );
  }
}
