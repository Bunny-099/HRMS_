import 'package:flutter/material.dart';
import 'package:hrms/widgets/soft_ui.dart';

class DashboardScreen extends StatefulWidget {
  static const String id = 'dashboard_screen';
  
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/images/app_logo/logo.jpeg',
                        width: 30,
                        height: 30,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Dashboard',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF69B4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFFF69B4),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: const Color(0xFFFFFACD),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Welcome message
              Text(
                'Welcome back!',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 30),
              
              // Dashboard cards
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.0,
                  children: [
                    _buildDashboardCard(
                      icon: Icons.people,
                      title: 'Employees',
                      subtitle: 'Manage employees',
                      color: const Color(0xFFFF69B4),
                    ),
                    _buildDashboardCard(
                      icon: Icons.access_time,
                      title: 'Attendance',
                      subtitle: 'Track attendance',
                      color: Colors.orange,
                    ),
                    _buildDashboardCard(
                      icon: Icons.work,
                      title: 'Leave',
                      subtitle: 'Apply for leave',
                      color: Colors.green,
                    ),
                    _buildDashboardCard(
                      icon: Icons.payments,
                      title: 'Payroll',
                      subtitle: 'View payslips',
                      color: Colors.purple,
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

  Widget _buildDashboardCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return SoftCard(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF69B4),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFD8BFD8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}