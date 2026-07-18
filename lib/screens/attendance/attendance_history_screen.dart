import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:hrms/services/api_services.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  static const String id = 'attendance_history_screen';

  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
  // 🔐 STATE & LOGIC 100% PRESERVED
  int presentCount = 0;
  int absentCount = 0;
  int lateCount = 0;
  int totalMinutes = 0;

  String get totalHoursFormatted {
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;
    return '${h}h ${m}m';
  }

  bool _loading = true;
  String? _error;

  List<dynamic> attendanceRecords = [];

  @override
  void initState() {
    super.initState();
    _fetchAttendance();
  }

  Future<void> _fetchAttendance() async {
    try {
      final res = await ApiService().get('/attendance/history');

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() {
          attendanceRecords = (data['attendance'] as List).map((r) {
            return AttendanceRecord(
              date: r['date'],
              clockIn: r['checkInTime'] != null
                  ? _formatTime(r['checkInTime'])
                  : '--',
              clockOut: r['checkOutTime'] != null
                  ? _formatTime(r['checkOutTime'])
                  : '--',
              status: r['status'] ?? 'Absent',
              hours: _calculateHours(r['checkInTime'], r['checkOutTime']),
            );
          }).toList();

          presentCount = 0;
          absentCount = 0;
          lateCount = 0;
          totalMinutes = 0;

          for (final record in attendanceRecords) {
            final status = record.status.toUpperCase();

            if (status == 'PRESENT') presentCount++;
            if (status == 'ABSENT') absentCount++;
            if (status == 'LATE') lateCount++;

            // calculate total minutes
            if (record.hours != '--') {
              final parts = record.hours.split(' ');
              final h = int.parse(parts[0].replaceAll('h', ''));
              final m = int.parse(parts[1].replaceAll('m', ''));
              totalMinutes += (h * 60) + m;
            }
          }

          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load attendance';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Server error';
        _loading = false;
      });
    }
  }

  // 🟢 Sleek Dark Glassmorphism Color Tokens (Synced across App)
  final Color bgDarkStart = const Color(0xFF090D16);
  final Color bgDarkEnd = const Color(0xFF111827);
  final Color textWhite = Colors.white;
  final Color textMuted = const Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: bgDarkStart,
        body: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF3B82F6),
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
        ),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: bgDarkStart,
        body: Center(
          child: Text(
            _error!,
            style: const TextStyle(color: Color(0xFFEF4444), fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bgDarkStart,
      body: Stack(
        children: [
          // 1. Deep Midnight Ambient Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgDarkStart, bgDarkEnd, const Color(0xFF0A0F1D)],
              ),
            ),
          ),

          // 🟢 2. Subtle Ambient Glow Orbs for Glass Effect
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.08), // Blue glow
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF10B981).withOpacity(0.06), // Emerald glow
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Attendance History',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      _buildGlassIconButton(
                        icon: Icons.filter_list_rounded,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 🟢 Summary Cards (Frosted Glass)
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Present',
                          value: presentCount.toString(),
                          color: const Color(0xFF10B981), // Emerald
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Absent',
                          value: absentCount.toString(),
                          color: const Color(0xFFEF4444), // Red
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Late',
                          value: lateCount.toString(),
                          color: const Color(0xFFF59E0B), // Amber
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          title: 'Hours',
                          value: totalHoursFormatted,
                          color: const Color(0xFF3B82F6), // Blue
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // History list Header
                  Row(
                    children: [
                      Text(
                        'Recent Records',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // 🟢 History list (Glassmorphic Rows)
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: attendanceRecords.length,
                      itemBuilder: (context, index) {
                        final AttendanceRecord record = attendanceRecords[index];
                        return _buildAttendanceRecord(record);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Ultra-Minimal Frosted Glass Summary Card
  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: color,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🟢 Ultra-Minimal Frosted Glass Attendance Record Row
  Widget _buildAttendanceRecord(AttendanceRecord record) {
    Color statusColor = const Color(0xFF94A3B8); // Default slate

    final status = record.status.toUpperCase();

    // Sleek Dark Theme Status Colors
    if (status == 'PRESENT') {
      statusColor = const Color(0xFF10B981); // Emerald
    } else if (status == 'ABSENT') {
      statusColor = const Color(0xFFEF4444); // Red
    } else if (status == 'LEAVE') {
      statusColor = const Color(0xFF3B82F6); // Blue
    } else if (status == 'LATE') {
      statusColor = const Color(0xFFF59E0B); // Amber
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // Date Stack
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        record.date,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Total: ${record.hours}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),

                // In/Out Times Stack
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.login_rounded, size: 12, color: Color(0xFF10B981)),
                          const SizedBox(width: 4),
                          Text(
                            record.clockIn,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8),
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.logout_rounded, size: 12, color: Color(0xFFEF4444)),
                          const SizedBox(width: 4),
                          Text(
                            record.clockOut,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.8),
                              fontFeatures: const [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Text(
                    record.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for sleek glass buttons in Header
  Widget _buildGlassIconButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// 🔐 TOP LEVEL LOGIC & CLASSES PRESERVED 100%
class AttendanceRecord {
  final String date;
  final String clockIn;
  final String clockOut;
  final String status;
  final String hours;

  AttendanceRecord({
    required this.date,
    required this.clockIn,
    required this.clockOut,
    required this.status,
    required this.hours,
  });
}

String _formatTime(String iso) {
  final dt = DateTime.parse(iso);
  return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}

String _calculateHours(String? inTime, String? outTime) {
  if (inTime == null || outTime == null) return '--';

  final start = DateTime.parse(inTime);
  final end = DateTime.parse(outTime);
  final diff = end.difference(start);

  final hours = diff.inHours;
  final minutes = diff.inMinutes % 60;

  return '${hours}h ${minutes}m';
}