import 'package:flutter/material.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/screens/dashboards/admin/admin_dashboard.dart';
import 'package:hrms/screens/dashboards/employee/employee_dashboard.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }
  Future<void> _checkAuthAndNavigate() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final role = prefs.getString('role');

  await Future.delayed(const Duration(seconds: 2)); // splash delay

  if (!mounted) return;

  if (token != null && token.trim().isNotEmpty) {

    if (role?.toUpperCase() == 'ADMIN') {

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const EmployeeDashboard()),
      );
    }
  } else {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),  // Light yellow
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SoftCard(
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: const Color(0xFFFFFACD),  // Light yellow
                  ),
                  child: Image.asset(
                    'assets/images/app_logo/logo.jpeg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'E-Smart HR',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Human Resource Management System',
                style: const TextStyle(
                  fontSize: 16,
                  color: const Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 50),
              SoftCard(
                child: Column(
                  children: [
                    Text(
                      'Welcome to E-Smart HR',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF69B4),  // Pink
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Manage your workforce efficiently',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF69B4),  // Pink
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}