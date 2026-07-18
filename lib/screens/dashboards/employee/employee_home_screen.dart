import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:hrms/screens/attendance/mark_attendance_screen.dart';
import 'package:hrms/screens/leave/my_leaves_screen.dart';
import 'package:hrms/screens/payroll/monthly_payslip_screen.dart';
import 'package:hrms/screens/employee/employee_profile_screen.dart';
import 'package:hrms/services/employee_service.dart';

class EmployeeHomeScreen extends StatefulWidget {
  const EmployeeHomeScreen({super.key});

  @override
  State<EmployeeHomeScreen> createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  // 🔐 BACKEND LOGIC 100% PRESERVED
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
      debugPrint('PROFILE ERROR: $e');
      setState(() => loading = false);
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

  // 🟢 Sleek Dark Glassmorphism Color Tokens
  final Color bgDarkStart = const Color(0xFF090D16);
  final Color bgDarkEnd = const Color(0xFF111827);
  final Color textWhite = Colors.white;
  final Color textMuted = const Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkStart,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgDarkStart, bgDarkEnd, const Color(0xFF0A0F1D)],
              ),
            ),
          ),

          // Ambient Glow
          Positioned(top: -100, left: -50, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3B82F6).withOpacity(0.08)))),
          Positioned(bottom: -50, right: -100, child: Container(width: 350, height: 350, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF8B5CF6).withOpacity(0.06)))),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Welcome Section
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              backgroundImage: profile != null && profile!['profileImage'] != null
                                  ? NetworkImage("https://zenzio-hrms-akbyh6edccc6czgz.centralindia-01.azurewebsites.net${profile!['profileImage']}")
                                  : null,
                              child: profile == null || profile!['profileImage'] == null
                                  ? const Icon(Icons.person_outline_rounded, size: 40, color: Colors.white)
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            Text(loading ? 'Loading...' : (profile?['fullName'] ?? 'Employee'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
                            Text(loading ? 'Fetching details...' : (profile?['email'] ?? ''), style: TextStyle(fontSize: 14, color: textMuted)),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Align(alignment: Alignment.centerLeft, child: Text('My Services', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5))),
                  const SizedBox(height: 16),

                  // Feature Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.1,
                    children: [
                      _buildFeatureCard(Icons.access_time_rounded, 'Attendance', const Color(0xFF3B82F6), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarkAttendanceScreen()))),
                      _buildFeatureCard(Icons.event_note_rounded, 'My Leaves', const Color(0xFFF59E0B), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MyLeavesScreen()))),
                      _buildFeatureCard(Icons.receipt_long_rounded, 'Payslips', const Color(0xFF10B981), () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MonthlyPayslipScreen()))),
                      _buildFeatureCard(Icons.person_outline_rounded, 'Profile', const Color(0xFF8B5CF6), () async { await Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeeProfileScreen())); _loadEmployeeProfile(); }),
                    ],
                  ),

                  const SizedBox(height: 32),
                  const Align(alignment: Alignment.centerLeft, child: Text('My Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 0.5))),
                  const SizedBox(height: 16),

                  // Status Grid
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.8,
                    children: [
                      _buildStatusCard('Shift Time', dashboardLoading ? '...' : shiftTime, Icons.schedule_rounded, const Color(0xFF8B5CF6)),
                      _buildStatusCard('Status', dashboardLoading ? '...' : todayStatus, Icons.check_circle_outline_rounded, todayStatus == 'Present' ? const Color(0xFF10B981) : const Color(0xFFEF4444)),
                      _buildStatusCard('Leave Balance', '$leaveBalance days', Icons.event_available_rounded, const Color(0xFFF59E0B)),
                      _buildStatusCard('Next Payday', nextPayday, Icons.attach_money_rounded, const Color(0xFF3B82F6)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.08))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 32, color: color),
                const SizedBox(height: 12),
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String title, String value, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.03), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.white.withOpacity(0.08))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white), textAlign: TextAlign.center, maxLines: 1),
              Text(title, style: TextStyle(fontSize: 10, color: textMuted)),
            ],
          ),
        ),
      ),
    );
  }
}