import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/attendance_history_screen.dart';
import 'package:hrms/screens/employee/employee_list_screen.dart';
import 'package:hrms/screens/attendance/holiday_calendar_screen.dart';
import 'package:hrms/screens/payroll/salary_structure_screen.dart';
import 'package:hrms/services/admin_service.dart';
import 'package:hrms/widgets/soft_ui.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  Map<String, dynamic>? stats;
bool loading = true;
@override
void initState() {
  super.initState();
  _loadStats();
}

Future<void> _loadStats() async {
  final data = await AdminService.getAdminStats();
  setState(() {
    stats = data;
    loading = false;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD), // Light yellow background
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Welcome section
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFFFF69B4), // Pink
                        child: Icon(
                          Icons.admin_panel_settings,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Text(
                        'Welcome, Admin!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF69B4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'HR Management Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Admin-specific features grid
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'HR Management',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Grid of admin features
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 4, // Number of admin features
                  itemBuilder: (context, index) {
                    final adminFeatures = [
                      {
                        'icon': Icons.people,
                        'title': 'Employees',
                        'subtitle': 'Manage staff',
                        'color': const Color(0xFFFF69B4),
                        'route': '/employee-list',
                      },
                      {
                        'icon': Icons.event_available,
                        'title': 'Holidays',
                        'subtitle': 'Manage holidays',
                        'color': const Color(0xFF4CAF50),
                        'route': '/holidays',
                      },
                      {
                        'icon': Icons.access_time,
                        'title': 'Attendance',
                        'subtitle': 'View reports',
                        'color': const Color(0xFF2196F3),
                        'route': '/attendance-history',
                      },
                      {
                        'icon': Icons.payments,
                        'title': 'Payroll',
                        'subtitle': 'Manage salaries',
                        'color': const Color(0xFFFF9800),
                        'route': '/payroll-management',
                      },
                    ];

                    final feature = adminFeatures[index];

                    return GestureDetector(
                      onTap: () {
                        // Navigate to the respective admin feature screen
                        switch (index) {
                          case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const EmployeeListScreen()),
                            );
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const HolidayCalendarScreen()),
                            );
                            break;
                          case 2:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const AttendanceHistoryScreen()),
                            );
                            break;
                          case 3:
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const SalaryStructureScreen()),
                            );
                            break;
                        }
                      },
                      child: _buildFeatureCard(
                        icon: feature['icon'] as IconData,
                        title: feature['title'] as String,
                        subtitle: feature['subtitle'] as String,
                        color: feature['color'] as Color,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 30),

                // Quick stats section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quick Stats',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
  title: 'Present Today',
  value: loading ? '...' : stats!['presentToday'].toString(),
  icon: Icons.check_circle,
  color: Colors.green,
),
                    _buildStatCard(

                      title: 'Total Employees',
                      value: loading ? '...' : stats!['totalEmployees'].toString(),
                      icon: Icons.people,
                      color: const Color(0xFFFF69B4),
                    ),
                    _buildStatCard(
                      title: 'Pending Requests',
                      value:  loading ? '...' : stats!['pendingEmployees'].toString(),
                      icon: Icons.check_circle,
                      color: const Color(0xFF4CAF50),
                    ),
                    _buildStatCard(title: "Active Employees", value: loading ? '...' : stats!['activeEmployees'].toString(), icon: Icons.check_circle, color: Colors.indigo)
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard(
                      title: 'Absent Today',
                      value: '4',
                      icon: Icons.cancel,
                      color: const Color(0xFFFF5722),
                    ),
                    _buildStatCard(
                      title: 'Pending Leaves',
                      value: '3',
                      icon: Icons.pending_actions,
                      color: const Color(0xFFFF9800),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 30,
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF69B4),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}