import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/services/auth_service.dart';

class StaffListScreen extends StatefulWidget {
  final bool isSelectionMode;

  const StaffListScreen({super.key, this.isSelectionMode = false});

  @override
  State<StaffListScreen> createState() => _StaffListScreenState();
}

class _StaffListScreenState extends State<StaffListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddStaffDialog(BuildContext context, AppDatabase db, int branchId) {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final specialtyController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Salon Stylist / Staff"),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: "Stylist Name *",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: specialtyController,
                decoration: const InputDecoration(
                  labelText: "Specialty (e.g. Hair, Makeup, Nails) *",
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.trim().isEmpty ? "Specialty is required" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: "Phone Number (Optional)",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState?.validate() ?? false) {
                try {
                  await db.createStaff(
                    StaffCompanion(
                      branchId: drift.Value(branchId),
                      name: drift.Value(nameController.text.trim()),
                      specialty: drift.Value(specialtyController.text.trim()),
                      phone: drift.Value(phoneController.text.trim().isNotEmpty 
                          ? phoneController.text.trim() 
                          : null),
                    ),
                  );
                  if (context.mounted) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Staff added successfully!"), backgroundColor: Colors.green),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5A4DFF)),
            child: const Text("Save", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final auth = Provider.of<AuthService>(context);

    if (auth.currentBranch == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Stylists Management")),
        body: const Center(child: Text("Error: No active branch selected.")),
      );
    }

    final branchId = auth.currentBranch!.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: Text(widget.isSelectionMode ? "Select Stylist" : "Salon Stylists"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showAddStaffDialog(context, db, branchId),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Add Stylist", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5A4DFF)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search stylist by name or specialty...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim().toLowerCase();
                });
              },
            ),
            const SizedBox(height: 16),
            // Staff List
            Expanded(
              child: StreamBuilder<List<StaffData>>(
                stream: (db.select(db.staff)..where((tbl) => tbl.branchId.equals(branchId))).watch(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text("Error loading stylists: ${snapshot.error}"));
                  }

                  final list = snapshot.data ?? [];
                  final filteredList = list.where((item) {
                    return item.name.toLowerCase().contains(_searchQuery) ||
                        (item.specialty != null && item.specialty!.toLowerCase().contains(_searchQuery));
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.badge_outlined, size: 64, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text("No stylists registered yet", style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (ctx, i) {
                      final member = filteredList[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        elevation: 1,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.purple[100],
                            child: const Icon(Icons.face, color: Colors.purple),
                          ),
                          title: Text(member.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.star_outline, size: 14, color: Colors.amber),
                                  const SizedBox(width: 6),
                                  Text(member.specialty ?? "Stylist"),
                                ],
                              ),
                              if (member.phone != null && member.phone!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    const Icon(Icons.phone, size: 14, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(member.phone!),
                                  ],
                                ),
                              ]
                            ],
                          ),
                          trailing: widget.isSelectionMode 
                              ? ElevatedButton(
                                  onPressed: () => Navigator.pop(context, member),
                                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                  child: const Text("Select", style: TextStyle(color: Colors.white)),
                                )
                              : IconButton(
                                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text("Remove Stylist"),
                                        content: Text("Are you sure you want to remove ${member.name}?"),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("Cancel")),
                                          ElevatedButton(
                                            onPressed: () => Navigator.pop(ctx, true),
                                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                            child: const Text("Delete"),
                                          )
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await db.deleteStaff(member.id);
                                    }
                                  },
                                ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
