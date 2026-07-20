import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/mark_attendance_screen.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
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
      extendBodyBehindAppBar: true,
      appBar: GlassAppBar(
        title: 'E-Smart HR',
        showBackButton: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome section
                  GlassCard(
                    borderRadius: 24,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const Text(
                          'Welcome, John Doe!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            _buildStatusCard(
                              'Attendance',
                              attendanceStatus,
                              GlassTheme.successAccent,
                            ),
                            const SizedBox(width: 12),
                            _buildStatusCard(
                              'Shift',
                              shiftTiming,
                              GlassTheme.accentGlow,
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
                          Icons.calendar_today_rounded,
                          GlassTheme.warningAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          'Notifications',
                          '${notifications.length}',
                          Icons.notifications_rounded,
                          Colors.purpleAccent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  // Main navigation grid
                  const Padding(
                    padding: EdgeInsets.only(left: 4.0),
                    child: Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildDashboardCard(
                        Icons.fingerprint_rounded,
                        'Attendance',
                        'Mark & History',
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarkAttendanceScreen(),
                            ),
                          );
                        },
                        GlassTheme.accentGlow,
                      ),
                      _buildDashboardCard(
                        Icons.event_note_rounded,
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
                        GlassTheme.warningAccent,
                      ),
                      _buildDashboardCard(
                        Icons.person_rounded,
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
                        GlassTheme.successAccent,
                      ),
                      _buildDashboardCard(
                        Icons.payments_rounded,
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
                        Colors.purpleAccent,
                      ),
                      _buildDashboardCard(
                        Icons.assessment_rounded,
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
                        GlassTheme.errorAccent,
                      ),
                      _buildDashboardCard(
                        Icons.policy_rounded,
                        'Policies',
                        'View Documents',
                        () {
                          _showPoliciesDialog();
                        },
                        Colors.tealAccent,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
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
    return GlassCard(
      borderRadius: 20,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: GlassTheme.textMuted,
            ),
          ),
          const SizedBox(height: 4),
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
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }

  void _showPoliciesDialog() {
    showDialog(
      context: context,
      builder: (context) => GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(8),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Company Policies', style: TextStyle(color: Colors.white)),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildPolicyItem('HR Policy'),
                _buildPolicyItem('Women-Friendly Workplace'),
                _buildPolicyItem('Confidentiality Policy'),
                _buildPolicyItem('POSH Policy'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: GlassTheme.accentGlow)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPolicyItem(String policyName) {
    return ListTile(
      title: Text(policyName, style: const TextStyle(color: Colors.white70, fontSize: 14)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white30),
      onTap: () {
        Navigator.pop(context);
        _showPolicyDetails(policyName);
      },
    );
  }

  void _showPolicyDetails(String policyName) {
    showDialog(
      context: context,
      builder: (context) => GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(8),
        child: AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(policyName, style: const TextStyle(color: Colors.white)),
          content: const Text(
            'This is a sample policy content. In a real app, this would show the actual policy document.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK', style: TextStyle(color: GlassTheme.accentGlow)),
            ),
          ],
        ),
      ),
    );
  }
}
