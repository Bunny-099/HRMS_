import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/screens/attendance/attendance_history_screen.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/soft_theme.dart' as custom_theme;

class MarkAttendanceScreen extends StatefulWidget {
  static const String id = 'mark_attendance_screen';

  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final ApiService _api = ApiService();

  bool _isClockedIn = false;
  bool _loading = false;

  String _currentTime = '';
  String _currentDate = '';
  String _clockInTime = '';
  String _clockOutTime = '';
  String _statusText = '---';

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateDateTime();
    _loadTodayAttendance();

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _updateDateTime();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /* ================= TIME ================= */
  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      _currentTime =
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      _currentDate = '${now.day}/${now.month}/${now.year}';
    });
  }

  /* ================= GPS ================= */
  Future<Position> _getLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Please enable location services';
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      throw 'Location permission permanently denied';
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /* ================= LOAD TODAY ================= */
  Future<void> _loadTodayAttendance() async {
    try {
      final response = await _api.get('/attendance/today');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['attendance'];

        if (data != null) {
          setState(() {
            _clockInTime =
                data['checkInTime']?.toString().substring(11, 16) ?? '';
            _clockOutTime =
                data['checkOutTime']?.toString().substring(11, 16) ?? '';
            _isClockedIn = data['checkOutTime'] == null;
            _statusText = data['status'] ?? 'PRESENT';
          });
        }
      }
    } catch (_) {}
  }

  /* ================= CHECK IN ================= */
  Future<void> _checkIn() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      final pos = await _getLocation();

      final response = await _api.post(
        '/attendance/check-in',
        {
          'latitude': pos.latitude,
          'longitude': pos.longitude,
        },
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body)['attendance'];

        setState(() {
          _isClockedIn = true;
          _clockInTime = _currentTime;
          _statusText = data['status'] ?? 'PRESENT';
        });

        _showSnack('Check-in successful', Colors.green);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      _showSnack(e.toString(), Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  /* ================= CHECK OUT ================= */
  Future<void> _checkOut() async {
    if (_loading) return;

    setState(() => _loading = true);

    try {
      final response = await _api.post('/attendance/check-out', {});

      if (response.statusCode == 200) {
        setState(() {
          _isClockedIn = false;
          _clockOutTime = _currentTime;
        });

        _showSnack('Check-out successful', Colors.green);
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      _showSnack(e.toString(), Colors.red);
    } finally {
      setState(() => _loading = false);
    }
  }

  void _toggleAttendance() {
    if (_isClockedIn) {
      _checkOut();
    } else {
      _checkIn();
    }
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: color),
    );
  }

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_theme.SoftTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: custom_theme.SoftTheme.backgroundColor,
        elevation: 0,
        title: Text(
          'Attendance',
          style: TextStyle(
            color: custom_theme.SoftTheme.textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Theme(
            data: Theme.of(context).copyWith(
              cardColor: custom_theme.SoftTheme.backgroundColor,
              canvasColor: custom_theme.SoftTheme.backgroundColor,
              dialogBackgroundColor: custom_theme.SoftTheme.backgroundColor,
              textTheme: Theme.of(context).textTheme.copyWith(
                bodyMedium: TextStyle(
                  color: custom_theme.SoftTheme.primaryColor,
                ),
                bodyLarge: TextStyle(
                  color: custom_theme.SoftTheme.primaryColor,
                ),
              ),
            ),
            child: PopupMenuButton<String>(
              color: custom_theme.SoftTheme.backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color: custom_theme.SoftTheme.primaryColor,
                  width: 1,
                ),
              ),
              icon: Icon(
                Icons.more_vert,
                color: custom_theme.SoftTheme.textColor,
              ),
              onSelected: (value) {
                if (value == 'history') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendanceHistoryScreen(),
                    ),
                  );
                } else if (value == 'refresh') {
                  _loadTodayAttendance();
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'history',
                  textStyle: TextStyle(
                    color: custom_theme.SoftTheme.primaryColor,
                  ),
                  child: Text(
                    'Attendance History',
                  ),
                ),
                PopupMenuItem(
                  value: 'refresh',
                  textStyle: TextStyle(
                    color: custom_theme.SoftTheme.primaryColor,
                  ),
                  child: Text(
                    'Refresh',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Spacer to push content to center
              const Spacer(flex: 1),
              
              // Centered attendance details card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: custom_theme.SoftTheme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: custom_theme.SoftTheme.primaryColor.withValues(alpha: 0.2),
                      offset: const Offset(0, 4),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Today's Date
                    Text(
                      _currentDate,
                      style: TextStyle(
                        fontSize: 18,
                        color: custom_theme.SoftTheme.textColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Current Time (live)
                    Text(
                      _currentTime,
                      style: TextStyle(
                        fontSize: 32,
                        color: custom_theme.SoftTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Attendance Details from Backend
                    _buildDetailRow('Clock In', _clockInTime.isEmpty ? '--:--' : _clockInTime),
                    const SizedBox(height: 12),
                    _buildDetailRow('Clock Out', _clockOutTime.isEmpty ? '--:--' : _clockOutTime),
                    const SizedBox(height: 12),
                    _buildDetailRow('Status', _statusText),
                  ],
                ),
              ),
              
              // Spacer to push button to bottom
              const Spacer(flex: 2),
              
              // Fixed bottom button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _loading ? null : _toggleAttendance,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isClockedIn
                        ? Colors.orange
                        : custom_theme.SoftTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _isClockedIn ? 'Clock Out' : 'Clock In',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: custom_theme.SoftTheme.textColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: custom_theme.SoftTheme.primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
