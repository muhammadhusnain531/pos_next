import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/screens/main_screen.dart';
import 'package:posnext/services/auth_service.dart';
import 'package:posnext/screens/login_screen.dart';
import 'package:posnext/theme/app_theme.dart';

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
      theme: AppTheme.theme,
      home: const LoginScreen(),
    );
  }
}
