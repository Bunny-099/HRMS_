import 'package:shared_preferences/shared_preferences.dart';

class RoleUtils {
  // Get the current user's role from shared preferences
  static Future<String?> getCurrentUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  // Check if the current user is an admin
  static Future<bool> isAdmin() async {
    final role = await getCurrentUserRole();
    return role == 'ADMIN';
  }

  // Check if the current user is an employee
  static Future<bool> isEmployee() async {
    final role = await getCurrentUserRole();
    return role == 'EMPLOYEE' || role == 'USER';
  }

  // Validate if the user has access to a specific dashboard
  static Future<bool> hasAccessToAdminDashboard() async {
    return await isAdmin();
  }

  static Future<bool> hasAccessToEmployeeDashboard() async {
    return await isEmployee();
  }
}