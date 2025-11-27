import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/database_service.dart';

class ManageBranchesScreen extends StatefulWidget {
  const ManageBranchesScreen({super.key});

  @override
  State<ManageBranchesScreen> createState() => _ManageBranchesScreenState();
}

class _ManageBranchesScreenState extends State<ManageBranchesScreen> {
  @override
  Widget build(BuildContext context) {
    final database = Provider.of<AppDatabase>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Branches')),
      body: FutureBuilder<List<Branche>>(
        future: database.getAllBranches(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final branches = snapshot.data ?? [];

          if (branches.isEmpty) {
            return const Center(child: Text('No branches found. Add one!'));
          }

          return ListView.builder(
            itemCount: branches.length,
            itemBuilder: (context, index) {
              final branch = branches[index];
              return ListTile(
                leading: const CircleAvatar(child: Icon(Icons.store)),
                title: Text(branch.name),
                subtitle: Text(branch.address ?? 'No address'),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddBranchDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddBranchDialog(BuildContext context) {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Branch'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Branch Details', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Branch Name'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                ),
                const SizedBox(height: 16),
                const Text('Branch Admin Credentials', style: TextStyle(fontWeight: FontWeight.bold)),
                TextFormField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Admin Username'),
                  validator: (v) => v!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Admin Password'),
                  obscureText: true,
                  validator: (v) => v!.isEmpty ? 'Required' : null,
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
                  await db.createBranchWithAdmin(
                    branchName: nameController.text,
                    branchAddress: addressController.text,
                    adminUsername: usernameController.text,
                    adminPassword: passwordController.text,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    setState(() {}); // Refresh list
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Branch & Admin Created!')),
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
      ),
    );
  }
}
