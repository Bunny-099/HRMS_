import 'package:flutter/material.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/screens/auth/splash_screen.dart';
import 'package:hrms/screens/dashboards/admin/admin_dashboard.dart';
import 'package:hrms/screens/dashboards/employee/employee_dashboard.dart';


void main() {
  runApp(const ESmartHRApp());
}

class ESmartHRApp extends StatelessWidget {
  const ESmartHRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFACD),  // Light yellow
      ),
      home: const SplashScreen(),
    );
  }
}