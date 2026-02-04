import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/mark_attendance_screen.dart';
import 'package:hrms/screens/leave/leave_status_screen.dart';
import 'package:hrms/screens/payroll/monthly_payslip_screen.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:hrms/screens/self_service/my_leaves_screen.dart';
import 'package:hrms/screens/self_service/self_service_home_screen.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:hrms/services/employee_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  String shiftTime = '--';
  String todayStatus = '--';
  String nextPayday = '--';
  int leaveBalance = 0;

  bool dashboardLoading = true;

  Map<String, dynamic>? profile;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    _loadEmployeeProfile();
    _loadDashboardStatus();
  }

  Future<void> _loadEmployeeProfile() async {
    try {
      final data = await EmployeeService.getMyProfile();
      setState(() {
        profile = data;
        loading = false;
      });
    } catch (e) {
      print('PROFILE ERROR: $e');
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> _loadDashboardStatus() async {
    try {
      final data = await EmployeeService.getDashboardStatus();

      setState(() {
        shiftTime = data['shiftTime'] ?? '--';
        todayStatus = data['todayStatus'] ?? '--';
        leaveBalance = data['leaveBalance'] ?? 0;
        nextPayday = data['nextPayday'] ?? '--';
        dashboardLoading = false;
      });
    } catch (e) {
      debugPrint('DASHBOARD STATUS ERROR: $e');
      dashboardLoading = false;
    }
  }

  String getEmployeeName() {
    if (profile != null && profile!['fullName'] != null) {
      return profile!['fullName'];
    }
    return 'Employee';
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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: const Color(0xFFFF69B4),
                        backgroundImage:
                            profile != null && profile!['profileImage'] != null
                            ? NetworkImage(
                                "http://13.233.98.86:4000${profile!['profileImage']}",
                              )
                            : null,
                        child:
                            profile == null || profile!['profileImage'] == null
                            ? const Icon(
                                Icons.person,
                                size: 50,
                                color: Colors.white,
                              )
                            : null,
                      ),

                      const SizedBox(height: 15),
                      Text(
                        loading ? 'Loading...' : (profile?['fullName'] ?? '_'),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF69B4),
                        ),
                      ),

                      const SizedBox(height: 8),
                      Text(
                        loading
                            ? 'Fetching details...'
                            : profile?['email'] ?? 'Self Service Dashboard',

                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Employee-specific features grid
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Services',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Grid of employee features
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: 4, // Number of employee features
                  itemBuilder: (context, index) {
                    final employeeFeatures = [
                      {
                        'icon': Icons.access_time,
                        'title': 'Attendance',
                        'subtitle': 'Mark & view',
                        'color': const Color(0xFF2196F3),
                        'route': '/mark-attendance',
                      },
                      {
                        'icon': Icons.event_note,
                        'title': 'My Leaves',
                        'subtitle': 'check leave details',
                        'color': const Color(0xFFFF9800),
                        'route': '/apply-leave',
                      },
                      {
                        'icon': Icons.receipt,
                        'title': 'Payslips',
                        'subtitle': 'View salary',
                        'color': const Color(0xFF4CAF50),
                        'route': '/monthly-payslip',
                      },
                      {
                        'icon': Icons.person,
                        'title': 'Profile',
                        'subtitle': 'My details',
                        'color': const Color(0xFFFF69B4),
                        'route': '/employee-profile',
                      },
                    ];

                    final feature = employeeFeatures[index];

                    return GestureDetector(
                      onTap: () async {
                        // Navigate to the respective employee feature screen
                        switch (index) {
                          case 0:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MarkAttendanceScreen(),
                              ),
                            );
                            break;
                          case 1:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyLeavesScreen(),
                              ),
                            );
                            break;
                          case 2:
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MonthlyPayslipScreen(),
                              ),
                            );
                            break;
                          case 3:
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EmployeeProfileScreen(),
                              ),
                            );
                            _loadEmployeeProfile(); // 🔥 refresh image + name
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

                // Quick info section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'My Status',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _buildStatusCard(
                      title: 'Shift Time',
                      value: dashboardLoading ? 'Loading...' : shiftTime,
                      icon: Icons.schedule,
                      color: const Color(0xFFFF69B4),
                    ),

                    const SizedBox(width: 16), // ✅ clean spacing

                    _buildStatusCard(
                      title: 'Today\'s Status',
                      value: dashboardLoading ? 'Loading...' : todayStatus,
                      icon: Icons.check_circle,
                      color: todayStatus.contains('Holiday')
                          ? Colors.blue
                          : todayStatus == 'Present'
                          ? Colors.green
                          : todayStatus == 'On Leave'
                          ? Colors.orange
                          : Colors.red,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  children: [
                    _buildStatusCard(
                      title: 'Leave Balance',
                      value: '$leaveBalance days',
                      icon: Icons.event_available,
                      color: const Color(0xFFFF9800),
                    ),

                    const SizedBox(width: 16), // ✅ horizontal space

                    _buildStatusCard(
                      title: 'Next Payday',
                      value: nextPayday,
                      icon: Icons.attach_money,
                      color: const Color(0xFF2196F3),
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
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
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
              style: const TextStyle(fontSize: 12, color: Color(0xFFD8BFD8)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        height: 120, // 🔥 FIXED HEIGHT (KEY POINT)
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 🔥 CENTER EVERYTHING
          children: [
            Icon(icon, size: 28, color: color),
            const SizedBox(height: 10),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16, // 🔥 slightly smaller & consistent
                fontWeight: FontWeight.w600,
                color: Color(0xFFFF69B4),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
