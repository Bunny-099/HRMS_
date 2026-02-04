import 'package:flutter/material.dart';
import 'package:hrms/screens/dashboards/admin/admin_home_screen.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/utils/role_utils.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/screens/dashboards/admin/pending_requests_screen.dart';

import 'package:hrms/screens/dashboards/admin/admin_profile_placeholder.dart';


class AdminDashboard extends StatefulWidget {
  static const String id = 'admin_dashboard';
  
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _selectedIndex = 0;
  
final List<Widget> _adminScreens = [
  const AdminHomeScreen(),              // index 0
  const AdminProfilePlaceholder(),      // index 1
  const PendingRequestsScreen(),        // index 2
];



  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // Method to check if the user has admin role
  void _checkUserRole() async {
    bool isAdmin = await RoleUtils.isAdmin();
    
    if (!isAdmin) {
      // If user is not admin, redirect to login
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
              'E-Smart HR - Admin',
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
        children: _adminScreens,
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
          BottomNavigationBarItem(
    icon: Icon(Icons.pending_actions),
    label: 'Requests',
          ),
        ],
      ),
    );
  }
}