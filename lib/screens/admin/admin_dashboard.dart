import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/auth_service.dart';
import '../../services/database_service.dart';
import '../../theme/colors.dart';
import '../../theme/button_styles.dart';
import 'manage_branches_screen.dart';
import 'manage_users_screen.dart';
import '../login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'CŌNTOR 369',
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.8,
              ),
            ),
            Text(
              'ADMIN PORTAL',
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                letterSpacing: 2.2,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.mauve),
            onPressed: () {
              Provider.of<AuthService>(context, listen: false).logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          children: [
            _buildDashboardCard(
              context,
              'Manage Branches',
              Icons.store,
              AppColors.mauve,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageBranchesScreen()),
              ),
            ),
            _buildDashboardCard(
              context,
              'Manage Users',
              Icons.people,
              AppColors.blushDeep,
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ManageUsersScreen()),
              ),
            ),
            _buildDashboardCard(
              context,
              'Reports',
              Icons.bar_chart,
              AppColors.zinc,
              () {},
            ),
            _buildDashboardCard(
              context,
              'Database',
              Icons.storage,
              AppColors.mauveDeep,
              () => _showDatabaseOptions(context),
            ),
            _buildDashboardCard(
              context,
              'Settings',
              Icons.settings,
              AppColors.textLight,
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: AppColors.border),
        borderRadius: BorderRadius.circular(2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.playfairDisplay(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatabaseOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Database Management'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.save, color: Colors.blue),
              title: const Text('Backup Database'),
              subtitle: const Text('Save a copy of your data'),
              onTap: () async {
                Navigator.pop(ctx);
                try {
                  await Provider.of<AppDatabase>(context, listen: false).backupDatabase();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Database Backup Successful'), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Backup Failed: $e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.red),
              title: const Text('Restore Database'),
              subtitle: const Text('Restore from a backup file'),
              onTap: () {
                Navigator.pop(ctx);
                _showRestoreConfirmation(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showRestoreConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Restore'),
        content: const Text(
          'WARNING: Restoring the database will OVERWRITE all current data. This action cannot be undone.\n\n'
          'Are you sure you want to proceed?',
          style: TextStyle(color: Colors.red),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await Provider.of<AppDatabase>(context, listen: false).restoreDatabase();
                if (context.mounted) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Restore Successful'),
                      content: const Text('Database restored successfully. Please restart the application to apply changes.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            // Ideally, restart app or navigate to login
                            // For now, just close dialog
                            Navigator.pop(ctx);
                          }, 
                          child: const Text('OK')
                        ),
                      ],
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Restore Failed: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            child: const Text('Restore', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
