import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../theme/colors.dart';
import '../theme/button_styles.dart';
import 'main_screen.dart';
import 'admin/admin_dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isSetupMode = false;

  @override
  void initState() {
    super.initState();
    _checkSystemStatus();
  }

  Future<void> _checkSystemStatus() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    final hasUser = await auth.hasAnyUser();
    if (!hasUser) {
      setState(() => _isSetupMode = true);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleAction() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter username and password')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      
      if (_isSetupMode) {
        await authService.createSuperAdmin(
          _usernameController.text,
          _passwordController.text,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Super Admin Created! Please Login.')),
          );
          setState(() {
            _isSetupMode = false;
            _passwordController.clear();
          });
        }
      } else {
        final success = await authService.login(
          _usernameController.text,
          _passwordController.text,
        );

        if (mounted) {
          if (success) {
            if (authService.currentUser?.role == 'SuperAdmin') {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const MainSaleScreen()),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Invalid credentials')),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.beigeDeep,
              AppColors.beigeLight,
              AppColors.blushPale,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: AppColors.border),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Container(
                width: 360,
                padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 40),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.point_of_sale,
                      size: 48,
                      color: AppColors.mauve,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _isSetupMode ? 'Setup Super Admin' : 'CŌNTOR 369',
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.4, // 0.1em
                        color: AppColors.text,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isSetupMode ? 'SYSTEM INITIALIZATION' : 'ADMIN / SALES PORTAL',
                      style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2.5, // 0.25em
                        color: AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleAction,
                        style: _isSetupMode 
                            ? AppButtonStyles.primary.copyWith(
                                backgroundColor: const WidgetStatePropertyAll(AppColors.ok),
                              )
                            : AppButtonStyles.primary,
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(_isSetupMode ? 'CREATE ADMIN' : 'LOGIN'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : () async {
                          setState(() => _isLoading = true);
                          try {
                            final db = Provider.of<AppDatabase>(context, listen: false);
                            await db.seedDemoData();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Demo Salon Data seeded successfully! Logging in..."),
                                  backgroundColor: AppColors.ok,
                                ),
                              );
                              // Refresh state and autofill credentials
                              await _checkSystemStatus();
                              _usernameController.text = 'admin';
                              _passwordController.text = 'admin';
                              // Auto execute login action
                              await _handleAction();
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Error seeding demo data: $e"),
                                  backgroundColor: AppColors.bad,
                                ),
                              );
                            }
                          } finally {
                            if (mounted) {
                              setState(() => _isLoading = false);
                            }
                          }
                        },
                        style: AppButtonStyles.ghost,
                        icon: const Icon(Icons.playlist_add_check, size: 18),
                        label: const Text("SEED DEMO DATA"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
