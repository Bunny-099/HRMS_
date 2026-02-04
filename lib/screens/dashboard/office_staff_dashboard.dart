import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/mark_attendance_screen.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:hrms/screens/attendance/attendance_history_screen.dart';
import 'package:hrms/screens/leave/apply_leave_screen.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:hrms/screens/payroll/monthly_payslip_screen.dart';
import 'package:hrms/screens/performance/performance_home_screen.dart';
import 'package:hrms/screens/auth/login_screen.dart';

class OfficeStaffDashboard extends StatefulWidget {
  static const String id = 'office_staff_dashboard';

  const OfficeStaffDashboard({super.key});

  @override
  State<OfficeStaffDashboard> createState() => _OfficeStaffDashboardState();
}

class _OfficeStaffDashboardState extends State<OfficeStaffDashboard> {
  // Mock data for demonstration
  String attendanceStatus = 'Present';
  String shiftTiming = '9:30 AM - 6:00 PM';
  int leaveBalance = 12;
  List<String> notifications = [
    'Monthly payroll processed',
    'New policy added',
    'Team meeting tomorrow',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
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
              'E-Smart HR',
              style: TextStyle(
                color: Color(0xFFFF69B4),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, color: Color(0xFFFF69B4)),
          ),
        ],
      ),
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
                    color: const Color(0xFFFFFACD),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFFFFACD),
                        offset: Offset(-4, -4),
                        blurRadius: 8,
                      ),
                      BoxShadow(
                        color: Color(0xFFFF69B4),
                        offset: Offset(4, 4),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Welcome, John Doe!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF69B4),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildStatusCard(
                            'Attendance',
                            attendanceStatus,
                            Colors.green,
                          ),
                          _buildStatusCard(
                            'Shift',
                            shiftTiming,
                            Color(0xFFFF69B4),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Quick stats
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Leave Balance',
                        '$leaveBalance days',
                        Icons.calendar_today,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildStatCard(
                        'Notifications',
                        '${notifications.length}',
                        Icons.notifications,
                        Colors.purple,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Main navigation grid
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(height: 15),

                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 1.1,
                  children: [
                    _buildDashboardCard(
                      Icons.fingerprint,
                      'Attendance',
                      'Mark & View History',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MarkAttendanceScreen(),
                          ),
                        );
                      },
                      Color(0xFFFF69B4),
                    ),
                    _buildDashboardCard(
                      Icons.calendar_today,
                      'Leave',
                      'Apply & Track',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ApplyLeaveScreen(),
                          ),
                        );
                      },
                      Colors.orange,
                    ),
                    _buildDashboardCard(
                      Icons.person,
                      'Profile',
                      'View Details',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EmployeeProfileScreen(),
                          ),
                        );
                      },
                      Colors.green,
                    ),
                    _buildDashboardCard(
                      Icons.payments,
                      'Payroll',
                      'View Payslips',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MonthlyPayslipScreen(),
                          ),
                        );
                      },
                      Colors.purple,
                    ),
                    _buildDashboardCard(
                      Icons.assessment,
                      'Performance',
                      'View KPIs',
                      () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerformanceHomeScreen(),
                          ),
                        );
                      },
                      Colors.red,
                    ),
                    _buildDashboardCard(
                      Icons.policy,
                      'Policies',
                      'View Documents',
                      () {
                        _showPoliciesDialog();
                      },
                      Colors.teal,
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

  Widget _buildStatusCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFACD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFFFFFACD),
              offset: Offset(-2, -2),
              blurRadius: 4,
            ),
            BoxShadow(
              color: Color(0xFFFF69B4),
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 5),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return SoftCard(
      child: Column(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF69B4),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
    Color color,
  ) {
    return SoftCard(
      child: GestureDetector(
        onTap: onTap,
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
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showPoliciesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Company Policies'),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPolicyItem('HR Policy'),
              _buildPolicyItem('Women-Friendly Workplace Policy'),
              _buildPolicyItem('Confidentiality & Credential Policy'),
              _buildPolicyItem('POSH Policy'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String policyName) {
    return ListTile(
      title: Text(policyName),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // In a real app, this would navigate to the policy details
        Navigator.pop(context);
        _showPolicyDetails(policyName);
      },
    );
  }

  void _showPolicyDetails(String policyName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(policyName),
        content: const Text(
          'This is a sample policy content. In a real app, this would show the actual policy document.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
