import 'package:flutter/material.dart';
import 'package:hrms/screens/leave/my_leaves_screen.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
import 'mark_attendance_screen.dart';
import 'attendance_history_screen.dart';
import '../leave/apply_leave_screen.dart';
import 'holiday_calendar_screen.dart';

class AttendanceLeaveHomeScreen extends StatefulWidget {
  static const String id = 'attendance_leave_home_screen';
  
  const AttendanceLeaveHomeScreen({super.key});

  @override
  State<AttendanceLeaveHomeScreen> createState() => _AttendanceLeaveHomeScreenState();
}

class _AttendanceLeaveHomeScreenState extends State<AttendanceLeaveHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Attendance & Leave',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.notifications_outlined, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // Quick Actions Title
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Action buttons grid
                Expanded(
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildActionCard(
                        icon: Icons.access_time_rounded,
                        title: 'Mark Attendance',
                        subtitle: 'Clock in/out',
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MarkAttendanceScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.history_rounded,
                        title: 'Attendance History',
                        subtitle: 'View records',
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AttendanceHistoryScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.work_outline_rounded,
                        title: 'Apply Leave',
                        subtitle: 'Request time off',
                        color: Colors.orangeAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ApplyLeaveScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.check_circle_outline_rounded,
                        title: 'Leave Status',
                        subtitle: 'Track requests',
                        color: GlassTheme.successAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyLeavesScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.calendar_month_rounded,
                        title: 'Holiday Calendar',
                        subtitle: 'View holidays',
                        color: GlassTheme.errorAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HolidayCalendarScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
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
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
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
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
