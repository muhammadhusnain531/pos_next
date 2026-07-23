import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:posnext/services/database_service.dart';
import 'package:posnext/services/auth_service.dart';
import 'package:posnext/screns/customer_screens/customer_list_screen.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  // Cache maps for resolving names in UI
  Map<int, Customer> _customerMap = {};
  Map<int, StaffData> _staffMap = {};
  Map<int, Product> _serviceMap = {};

  @override
  void initState() {
    super.initState();
    _loadReferenceData();
  }

  Future<void> _loadReferenceData() async {
    setState(() => _isLoading = true);
    try {
      final db = Provider.of<AppDatabase>(context, listen: false);
      final auth = Provider.of<AuthService>(context, listen: false);
      final branchId = auth.currentBranch?.id ?? 0;

      final customers = await db.getAllCustomers();
      final staffList = await db.getAllStaff(branchId);
      final services = await (db.select(db.products)..where((t) => t.isService.equals(true))).get();

      setState(() {
        _customerMap = {for (var c in customers) c.id: c};
        _staffMap = {for (var s in staffList) s.id: s};
        _serviceMap = {for (var s in services) s.id: s};
      });
    } catch (e) {
      debugPrint("Error loading reference data: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showBookingDialog(BuildContext context, AppDatabase db, int branchId) {
    Customer? selectedCustomer;
    Product? selectedService;
    StaffData? selectedStaff;
    DateTime bookingDate = _selectedDate;
    TimeOfDay bookingTime = const TimeOfDay(hour: 9, minute: 0);
    final notesController = TextEditingController();
    final stateKey = GlobalKey<FormState>();

    // Filter services out of service map
    final services = _serviceMap.values.toList();
    final staffList = _staffMap.values.toList();

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text("Book Appointment"),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Form(
                    key: stateKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Customer Selector
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(selectedCustomer == null 
                              ? "Select Customer *" 
                              : "Customer: ${selectedCustomer!.name}"),
                          subtitle: Text(selectedCustomer == null 
                              ? "No client selected" 
                              : "Phone: ${selectedCustomer!.phone}"),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () async {
                            final result = await Navigator.push<Customer>(
                              context,
                              MaterialPageRoute(builder: (_) => const CustomerListScreen(isSelectionMode: true)),
                            );
                            if (result != null) {
                              setDialogState(() => selectedCustomer = result);
                            }
                          },
                        ),
                        const Divider(),
                        
                        // Service Dropdown
                        DropdownButtonFormField<Product>(
                          decoration: const InputDecoration(
                            labelText: "Select Service *",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedService,
                          items: services.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text("${s.name} (Rs. ${s.price.toStringAsFixed(2)})"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setDialogState(() => selectedService = val);
                          },
                          validator: (val) => val == null ? "Service is required" : null,
                        ),
                        const SizedBox(height: 16),

                        // Stylist/Staff Dropdown
                        DropdownButtonFormField<StaffData>(
                          decoration: const InputDecoration(
                            labelText: "Select Stylist *",
                            border: OutlineInputBorder(),
                          ),
                          value: selectedStaff,
                          items: staffList.map((s) {
                            return DropdownMenuItem(
                              value: s,
                              child: Text("${s.name} - ${s.specialty ?? 'Stylist'}"),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setDialogState(() => selectedStaff = val);
                          },
                          validator: (val) => val == null ? "Stylist is required" : null,
                        ),
                        const SizedBox(height: 16),

                        // Date & Time pickers
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: bookingDate,
                                    firstDate: DateTime.now().subtract(const Duration(days: 30)),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (picked != null) {
                                    setDialogState(() => bookingDate = picked);
                                  }
                                },
                                icon: const Icon(Icons.calendar_today),
                                label: Text("${bookingDate.year}-${bookingDate.month}-${bookingDate.day}"),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () async {
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: bookingTime,
                                  );
                                  if (picked != null) {
                                    setDialogState(() => bookingTime = picked);
                                  }
                                },
                                icon: const Icon(Icons.access_time),
                                label: Text(bookingTime.format(context)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Notes Field
                        TextFormField(
                          controller: notesController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: "Notes (Optional)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedCustomer == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select a customer"), backgroundColor: Colors.orange),
                      );
                      return;
                    }
                    if (stateKey.currentState?.validate() ?? false) {
                      final apptTime = DateTime(
                        bookingDate.year,
                        bookingDate.month,
                        bookingDate.day,
                        bookingTime.hour,
                        bookingTime.minute,
                      );

                      try {
                        await db.createAppointment(
                          AppointmentsCompanion(
                            branchId: drift.Value(branchId),
                            customerId: drift.Value(selectedCustomer!.id),
                            serviceId: drift.Value(selectedService!.id),
                            staffId: drift.Value(selectedStaff!.id),
                            appointmentTime: drift.Value(apptTime),
                            durationMinutes: drift.Value(selectedService!.durationMinutes ?? 30),
                            status: const drift.Value('Pending'),
                            notes: drift.Value(notesController.text.trim().isNotEmpty 
                                ? notesController.text.trim() 
                                : null),
                          ),
                        );
                        if (context.mounted) {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Appointment booked successfully!"), backgroundColor: Colors.green),
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
                  child: const Text("Confirm Booking", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showStatusDialog(BuildContext context, AppDatabase db, Appointment appt) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("Change Appointment Status"),
        children: [
          _statusOption(context, db, appt, "Pending", Colors.orange),
          _statusOption(context, db, appt, "Confirmed", Colors.blue),
          _statusOption(context, db, appt, "Completed", Colors.green),
          _statusOption(context, db, appt, "Cancelled", Colors.red),
          _statusOption(context, db, appt, "No Show", Colors.grey),
        ],
      ),
    );
  }

  Widget _statusOption(BuildContext context, AppDatabase db, Appointment appt, String status, Color color) {
    return SimpleDialogOption(
      onPressed: () async {
        final updated = appt.copyWith(status: status);
        await db.updateAppointment(updated);
        if (context.mounted) Navigator.pop(context);
      },
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2), radius: 8),
          const SizedBox(width: 12),
          Text(status, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending': return Colors.orange;
      case 'Confirmed': return Colors.blue;
      case 'Completed': return Colors.green;
      case 'Cancelled': return Colors.red;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final db = Provider.of<AppDatabase>(context);
    final auth = Provider.of<AuthService>(context);

    if (auth.currentBranch == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Appointments")),
        body: const Center(child: Text("Error: No active branch linked to user.")),
      );
    }

    final branchId = auth.currentBranch!.id;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("Salon Booking Scheduler"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              onPressed: () => _showBookingDialog(context, db, branchId),
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text("Book Appointment", style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5A4DFF)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Picker Header Panel
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28),
                      onPressed: () => _changeDate(-1),
                    ),
                    TextButton.icon(
                      onPressed: () => _selectDate(context),
                      icon: const Icon(Icons.calendar_month, size: 24),
                      label: Text(
                        "${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 28),
                      onPressed: () => _changeDate(1),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Scheduler Timeline
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<List<Appointment>>(
                    stream: db.getAppointmentsForDate(branchId, _selectedDate).asStream(), // Watch wrapper
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text("Error fetching bookings: ${snapshot.error}"));
                      }

                      final bookings = snapshot.data ?? [];
                      if (bookings.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                              const SizedBox(height: 16),
                              Text("No appointments scheduled for this date", 
                                  style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: bookings.length,
                        itemBuilder: (ctx, i) {
                          final appt = bookings[i];
                          final customer = _customerMap[appt.customerId];
                          final stylist = _staffMap[appt.staffId];
                          final service = _serviceMap[appt.serviceId];

                          final timeStr = "${appt.appointmentTime.hour.toString().padLeft(2, '0')}:${appt.appointmentTime.minute.toString().padLeft(2, '0')}";
                          final statusColor = _getStatusColor(appt.status);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 1.5,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  // Time Block
                                  Container(
                                    width: 80,
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Column(
                                      children: [
                                        const Icon(Icons.access_time, size: 18, color: Colors.blue),
                                        const SizedBox(height: 4),
                                        Text(timeStr, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),

                                  // Client & Booking info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(customer?.name ?? "Guest Client", 
                                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () => _showStatusDialog(context, db, appt),
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: statusColor.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  appt.status,
                                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: statusColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Text("Service: ${service?.name ?? 'Salon Treatment'} (${appt.durationMinutes} mins)",
                                            style: TextStyle(color: Colors.grey[800])),
                                        const SizedBox(height: 2),
                                        Text("Stylist: ${stylist?.name ?? 'Unassigned Stylist'} (${stylist?.specialty ?? 'Stylist'})",
                                            style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                                        if (appt.notes != null) ...[
                                          const SizedBox(height: 6),
                                          Text("Notes: ${appt.notes}", style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12)),
                                        ]
                                      ],
                                    ),
                                  ),

                                  // Checkout Action Button
                                  if (appt.status == 'Completed') ...[
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        if (service != null) {
                                          Navigator.pop(context, {
                                            'action': 'checkout',
                                            'service': service,
                                            'appointment': appt,
                                          });
                                        } else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text("Error: Service details missing"), backgroundColor: Colors.red),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white),
                                      label: const Text("Checkout to POS", style: TextStyle(color: Colors.white)),
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    ),
                                  ] else ...[
                                    // Status quick changer shortcut
                                    OutlinedButton(
                                      onPressed: () => _showStatusDialog(context, db, appt),
                                      child: const Text("Status"),
                                    ),
                                  ],
                                ],
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
