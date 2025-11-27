import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drift/drift.dart' as drift;
import '../../services/database_service.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Users (PCs)')),
      body: FutureBuilder<List<User>>(
        future: database.getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final users = snapshot.data ?? [];

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getRoleColor(user.role),
                  child: Text(user.role[0].toUpperCase()),
                ),
                title: Text(user.username),
                subtitle: Text('Role: ${user.role} | Branch ID: ${user.branchId ?? "None"}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddUserDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'SuperAdmin': return Colors.red;
      case 'BranchAdmin': return Colors.orange;
      default: return Colors.blue;
    }
  }

  void _showAddUserDialog(BuildContext context) {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    String selectedRole = 'User';
    Branche? selectedBranch;
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Add New User'),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(labelText: 'Username'),
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (v) => v!.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: const InputDecoration(labelText: 'Role'),
                      items: const [
                        DropdownMenuItem(value: 'User', child: Text('User (PC)')),
                        DropdownMenuItem(value: 'BranchAdmin', child: Text('Branch Admin')),
                      ],
                      onChanged: (v) => setState(() => selectedRole = v!),
                    ),
                    const SizedBox(height: 16),
                    FutureBuilder<List<Branche>>(
                      future: Provider.of<AppDatabase>(context, listen: false).getAllBranches(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        final branches = snapshot.data!;
                        return DropdownButtonFormField<Branche>(
                          value: selectedBranch,
                          decoration: const InputDecoration(labelText: 'Assign to Branch'),
                          items: branches.map((b) => DropdownMenuItem(value: b, child: Text(b.name))).toList(),
                          onChanged: (v) => setState(() => selectedBranch = v),
                          validator: (v) => v == null ? 'Required' : null,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    try {
                      final db = Provider.of<AppDatabase>(context, listen: false);
                      await db.createUser(UsersCompanion(
                        username: drift.Value(usernameController.text),
                        password: drift.Value(passwordController.text),
                        role: drift.Value(selectedRole),
                        branchId: drift.Value(selectedBranch!.id),
                        isActive: const drift.Value(true),
                      ));
                      if (mounted) {
                        Navigator.pop(context);
                        this.setState(() {}); // Refresh parent list
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('User Created!')),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Create'),
              ),
            ],
          );
        },
      ),
    );
  }
}
