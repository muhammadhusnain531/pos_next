import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import 'database_service.dart';

class AuthService extends ChangeNotifier {
  final AppDatabase _db;
  User? _currentUser;
  Branche? _currentBranch;

  AuthService(this._db);

  User? get currentUser => _currentUser;
  Branche? get currentBranch => _currentBranch;
  bool get isAuthenticated => _currentUser != null;

  Future<bool> login(String username, String password) async {
    // TODO: Implement password hashing comparison
    final user = await (_db.select(_db.users)..where((t) => t.username.equals(username) & t.password.equals(password))).getSingleOrNull();

    if (user != null) {
      _currentUser = user;
      if (user.branchId != null) {
        _currentBranch = await (_db.select(_db.branches)..where((t) => t.id.equals(user.branchId!))).getSingleOrNull();
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _currentUser = null;
    _currentBranch = null;
    notifyListeners();
  }

  bool hasPermission(String requiredRole) {
    if (_currentUser == null) return false;
    if (_currentUser!.role == 'SuperAdmin') return true;
    if (_currentUser!.role == 'BranchAdmin' && requiredRole != 'SuperAdmin') return true;
    return _currentUser!.role == requiredRole;
  }

  Future<bool> hasAnyUser() => _db.hasAnyUser();

  Future<int> createSuperAdmin(String username, String password) => _db.createSuperAdmin(username, password);
}
