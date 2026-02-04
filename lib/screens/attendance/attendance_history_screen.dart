import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:hrms/services/api_services.dart';

class AttendanceHistoryScreen extends StatefulWidget {
  static const String id = 'attendance_history_screen';

  const AttendanceHistoryScreen({super.key});

  @override
  State<AttendanceHistoryScreen> createState() =>
      _AttendanceHistoryScreenState();
}

class _AttendanceHistoryScreenState extends State<AttendanceHistoryScreen> {
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

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFACD),
                        shape: BoxShape.circle,
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
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'Attendance History',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFACD),
                      shape: BoxShape.circle,
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
                    child: const Icon(
                      Icons.filter_list,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Present',
                      value: presentCount.toString(),
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Absent',
                      value: absentCount.toString(),
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Late',
                      value:  lateCount.toString(),
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Hours',
                      value: totalHoursFormatted,
                      color: const Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // History list
              Expanded(
                child: ListView.builder(
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
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
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
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(fontSize: 14, color: Color(0xFFFF69B4)),
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceRecord(AttendanceRecord record) {
Color statusColor = Colors.grey;

final status = record.status.toUpperCase();

if (status == 'PRESENT') {
  statusColor = Colors.green;
} else if (status == 'ABSENT') {
  statusColor = Colors.red;
} else if (status == 'LEAVE') {
  statusColor = Colors.blue;
}


    return Container(
      margin: const EdgeInsets.only(bottom: 10),
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
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Date
            Expanded(
              flex: 2,
              child: Text(
                record.date,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ),

            // Clock in
            Expanded(
              child: Text(
                record.clockIn,
                style: const TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFFF69B4),
                ),
              ),
            ),

            // Clock out
            Expanded(
              child: Text(
                record.clockOut,
                style: const TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFFF69B4),
                ),
              ),
            ),

            // Hours
            Expanded(
              child: Text(
                record.hours,
                style: const TextStyle(
                  fontSize: 14,
                  color: const Color(0xFFFF69B4),
                ),
              ),
            ),

            // Status
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                record.status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


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
