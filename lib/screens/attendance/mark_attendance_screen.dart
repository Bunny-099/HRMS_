import 'dart:async';
import 'dart:convert';
import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hrms/screens/attendance/attendance_history_screen.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/soft_theme.dart' as custom_theme; // Kept intact

class MarkAttendanceScreen extends StatefulWidget {
  static const String id = 'mark_attendance_screen';

  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  final ApiService _api = ApiService();

  // 🔐 STATE & LOGIC 100% PRESERVED
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

        _showSnack('Check-in successful', const Color(0xFF10B981));
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      _showSnack(e.toString(), const Color(0xFFEF4444));
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

        _showSnack('Check-out successful', const Color(0xFF10B981));
      } else {
        throw jsonDecode(response.body)['message'];
      }
    } catch (e) {
      _showSnack(e.toString(), const Color(0xFFEF4444));
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

  // 🟢 Upgraded SnackBar for Dark Glassmorphism
  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              color == const Color(0xFF10B981) ? Icons.check_circle_outline_rounded : Icons.error_outline_rounded,
              color: color,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                msg,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
        margin: const EdgeInsets.all(20),
        elevation: 0,
      ),
    );
  }

  // 🟢 Sleek Dark Glassmorphism Color Tokens (Synced across App)
  final Color bgDarkStart = const Color(0xFF090D16);
  final Color bgDarkEnd = const Color(0xFF111827);
  final Color textWhite = Colors.white;
  final Color textMuted = const Color(0xFF94A3B8);

  /* ================= UI ================= */
  @override
  Widget build(BuildContext context) {
    // Dynamic Accent based on state
    final Color currentAccent = _isClockedIn ? const Color(0xFFF59E0B) : const Color(0xFF10B981);

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

          // 🟢 2. Subtle Dynamic Ambient Glow Orbs for Glass Effect
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            top: -100,
            left: -50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentAccent.withOpacity(0.08), // Dynamic glow (Green -> Amber)
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.06), // Blue glow
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // 🟢 Custom Glass Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildGlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),
                      const Text(
                        'Live Attendance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),
                      // Glassmorphic Theme applied to PopupMenuButton
                      Theme(
                        data: Theme.of(context).copyWith(
                          cardColor: const Color(0xFF1E293B),
                          splashColor: Colors.white.withOpacity(0.1),
                          hoverColor: Colors.white.withOpacity(0.05),
                        ),
                        child: PopupMenuButton<String>(
                          color: const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                          ),
                          icon: _buildGlassIconButton(
                            icon: Icons.more_vert_rounded,
                            onTap: null, // Let popup button handle the tap
                          ),
                          offset: const Offset(0, 50),
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
                              child: Row(
                                children: [
                                  Icon(Icons.history_rounded, color: textMuted, size: 20),
                                  const SizedBox(width: 12),
                                  const Text('Attendance History', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'refresh',
                              child: Row(
                                children: [
                                  Icon(Icons.refresh_rounded, color: textMuted, size: 20),
                                  const SizedBox(width: 12),
                                  const Text('Refresh', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Spacer to push content to center
                  const Spacer(flex: 1),

                  // 🟢 4. FROSTED GLASS ATTENDANCE CARD
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: currentAccent.withOpacity(0.15),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Current Date
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _currentDate,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: textMuted,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Live Current Time
                            Text(
                              _currentTime,
                              style: TextStyle(
                                fontSize: 64,
                                color: currentAccent,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -2.0,
                                fontFeatures: const [FontFeature.tabularFigures()],
                                shadows: [
                                  BoxShadow(
                                    color: currentAccent.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Attendance Details (In/Out/Status)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withOpacity(0.05)),
                              ),
                              child: Column(
                                children: [
                                  _buildDetailRow(
                                    Icons.login_rounded,
                                    'Clock In',
                                    _clockInTime.isEmpty ? '--:--' : _clockInTime,
                                    valueColor: const Color(0xFF10B981),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(color: Colors.white10, height: 1, thickness: 1),
                                  ),
                                  _buildDetailRow(
                                    Icons.logout_rounded,
                                    'Clock Out',
                                    _clockOutTime.isEmpty ? '--:--' : _clockOutTime,
                                    valueColor: const Color(0xFFEF4444),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                    child: Divider(color: Colors.white10, height: 1, thickness: 1),
                                  ),
                                  _buildDetailRow(
                                    Icons.donut_large_rounded,
                                    'Status',
                                    _statusText,
                                    valueColor: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Spacer to push button to bottom
                  const Spacer(flex: 2),

                  // 🟢 5. SLEEK ACTION BUTTON (Dynamic State)
                  GestureDetector(
                    onTap: _loading ? null : _toggleAttendance,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: double.infinity,
                      height: 56,
                      decoration: BoxDecoration(
                        color: _loading
                            ? currentAccent.withOpacity(0.5)
                            : currentAccent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: currentAccent.withOpacity(0.5),
                          width: 1,
                        ),
                        boxShadow: [
                          if (!_loading)
                            BoxShadow(
                              color: currentAccent.withOpacity(0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: _loading
                          ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isClockedIn ? Icons.front_hand_rounded : Icons.touch_app_rounded,
                            color: currentAccent,
                            size: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isClockedIn ? 'CLOCK OUT' : 'CLOCK IN',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: currentAccent,
                            ),
                          ),
                        ],
                      ),
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

  // Helper Widget for Detail Rows
  Widget _buildDetailRow(IconData icon, String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textMuted),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            color: valueColor ?? Colors.white,
            fontWeight: FontWeight.w700,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }

  // Helper Widget for sleek glass buttons in Header
  Widget _buildGlassIconButton({required IconData icon, VoidCallback? onTap}) {
    // If onTap is null, it relies on the parent (like PopupMenuButton) to handle the tap
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
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