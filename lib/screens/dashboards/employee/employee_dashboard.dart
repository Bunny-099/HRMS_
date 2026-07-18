import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:hrms/screens/dashboards/employee/employee_home_screen.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/utils/role_utils.dart';
import 'package:hrms/widgets/soft_ui.dart'; // Kept intact to avoid breaking imports
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

  // 🟢 Employee-specific routes (100% PRESERVED)
  final List<Widget> _employeeScreens = [
    const EmployeeHomeScreen(),
    const EmployeeProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _checkUserRole();
  }

  // 🔐 Method to check if the user has employee role (100% PRESERVED)
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
    // 🟢 Sleek Dark Glassmorphism Color Tokens (Synced across app)
    const Color bgDarkStart = Color(0xFF090D16);
    const Color textWhite = Colors.white;
    const Color accentBlue = Color(0xFF3B82F6);
    const Color textMuted = Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgDarkStart,

      // 🟢 1. FROSTED GLASS APP BAR
      appBar: AppBar(
        backgroundColor: bgDarkStart.withOpacity(0.75),
        elevation: 0,
        centerTitle: true,
        // Applies true blur behind the app bar when scrolling content underneath
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white.withOpacity(0.08),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/app_logo/logo.jpeg',
                width: 28,
                height: 28,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.business_center_rounded,
                  size: 26,
                  color: accentBlue,
                ),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'E-Smart HR',
              style: TextStyle(
                color: textWhite,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: accentBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: accentBlue.withOpacity(0.3), width: 1),
              ),
              child: const Text(
                'Employee',
                style: TextStyle(
                  color: accentBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ],
        ),
        actions: [
          // Sleek Logout Action Button (Exact SharedPreferences logic preserved!)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('token');
                await prefs.remove('role');

                if (!mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              tooltip: 'Logout',
              icon: Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFEF4444).withOpacity(0.25),
                  ),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: Color(0xFFF87171), // Professional subtle coral red
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),

      // 🟢 2. MAIN BODY (IndexedStack preserved 100%)
      body: IndexedStack(
        index: _selectedIndex,
        children: _employeeScreens,
      ),

      // 🟢 3. FROSTED GLASS BOTTOM NAVIGATION DOCK
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF0A0F1D).withOpacity(0.85),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent, // Handled by glass container
              selectedItemColor: accentBlue, // Sleek SaaS Blue
              unselectedItemColor: textMuted,
              elevation: 0,
              currentIndex: _selectedIndex,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.dashboard_outlined),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.dashboard_rounded),
                  ),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline_rounded),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_rounded),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}