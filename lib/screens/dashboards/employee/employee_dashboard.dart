import 'package:flutter/material.dart';
import 'package:hrms/screens/dashboards/employee/employee_home_screen.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/utils/role_utils.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';


class EmployeeDashboard extends StatefulWidget {
  static const String id = 'employee_dashboard';
  
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  int _selectedIndex = 0;
  
  // Employee-specific routes
final List<Widget> _employeeScreens = [
  const EmployeeHomeScreen(),
  const EmployeeProfileScreen(),
];


  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // Method to check if the user has employee role
  void _checkUserRole() async {
    bool isEmployee = await RoleUtils.isEmployee();
    
    if (!isEmployee) {
      // If user is not employee, redirect to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFACD),
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/app_logo/logo.jpeg',
              width: 30,
              height: 30,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            const Text(
              'E-Smart HR - Employee',
              style: TextStyle(
                color: Color(0xFFFF69B4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () async {
              // Clear user session
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');
              await prefs.remove('role');
              
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.logout,
              color: Color(0xFFFF69B4),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _employeeScreens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFFFFACD),
        selectedItemColor: const Color(0xFFFF69B4),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}