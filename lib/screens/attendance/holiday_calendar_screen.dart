import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';

class HolidayCalendarScreen extends StatefulWidget {
  static const String id = 'holiday_calendar_screen';

  const HolidayCalendarScreen({super.key});

  @override
  State<HolidayCalendarScreen> createState() => _HolidayCalendarScreenState();
}

class _HolidayCalendarScreenState extends State<HolidayCalendarScreen> {
  // 🔐 DATA PRESERVED 100%
  List<Holiday> holidays = [
    Holiday(
      id: 1,
      name: 'New Year',
      date: DateTime(2024, 1, 1),
      type: 'National Holiday',
    ),
    Holiday(
      id: 2,
      name: 'Republic Day',
      date: DateTime(2024, 1, 26),
      type: 'National Holiday',
    ),
    Holiday(
      id: 3,
      name: 'Holi',
      date: DateTime(2024, 3, 25),
      type: 'Festival',
    ),
    Holiday(
      id: 4,
      name: 'Good Friday',
      date: DateTime(2024, 3, 29),
      type: 'Religious Holiday',
    ),
    Holiday(
      id: 5,
      name: 'Labour Day',
      date: DateTime(2024, 5, 1),
      type: 'National Holiday',
    ),
    Holiday(
      id: 6,
      name: 'Independence Day',
      date: DateTime(2024, 8, 15),
      type: 'National Holiday',
    ),
    Holiday(
      id: 7,
      name: 'Gandhi Jayanti',
      date: DateTime(2024, 10, 2),
      type: 'National Holiday',
    ),
    Holiday(
      id: 8,
      name: 'Diwali',
      date: DateTime(2024, 11, 1),
      type: 'Festival',
    ),
  ];

  String _getDayName(int day) {
    switch (day) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'May';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Aug';
      case 9: return 'Sep';
      case 10: return 'Oct';
      case 11: return 'Nov';
      case 12: return 'Dec';
      default: return '';
    }
  }

  // 🟢 Sleek Dark Glassmorphism Color Tokens (Synced across app)
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
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.08), // Blue glow
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
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
                      // Back Button
                      _buildGlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),

                      // Title
                      const Text(
                        'Holiday Calendar',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),

                      // Calendar Icon
                      _buildGlassIconButton(
                        icon: Icons.calendar_month_rounded,
                        onTap: () {},
                        accentColor: const Color(0xFF10B981),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Holiday list
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: holidays.length,
                      itemBuilder: (context, index) {
                        final holiday = holidays[index];
                        return _buildHolidayCard(holiday);
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

  // 🟢 Ultra-Minimal Frosted Glass Holiday Card
  Widget _buildHolidayCard(Holiday holiday) {
    String day = _getDayName(holiday.date.weekday);
    String month = _getMonthName(holiday.date.month);
    String dayNumber = holiday.date.day.toString();

    // Sleek Dark Theme Accent Colors based on logic
    Color typeColor = const Color(0xFF3B82F6); // Default Blue
    if (holiday.type == 'National Holiday') {
      typeColor = const Color(0xFF10B981); // Emerald Green
    } else if (holiday.type == 'Religious Holiday') {
      typeColor = const Color(0xFF8B5CF6); // Royal Violet
    } else if (holiday.type == 'Festival') {
      typeColor = const Color(0xFFF59E0B); // Vibrant Amber
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                // 🟢 Sleek Date Badge / Calendar Leaf
                Container(
                  width: 60,
                  height: 64,
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: typeColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        day.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: typeColor.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        dayNumber,
                        style: TextStyle(
                          fontSize: 18,
                          color: typeColor,
                          fontWeight: FontWeight.w800,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        month.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          color: typeColor.withOpacity(0.8),
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),

                // 🟢 Holiday Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        holiday.name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${holiday.date.day} ${month}, ${holiday.date.year}',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Holiday Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: typeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: typeColor.withOpacity(0.2)),
                        ),
                        child: Text(
                          holiday.type,
                          style: TextStyle(
                            fontSize: 11,
                            color: typeColor,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
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

  // Helper Widget for sleek glass buttons in Header
  Widget _buildGlassIconButton({required IconData icon, required VoidCallback onTap, Color? accentColor}) {
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
              color: accentColor != null ? accentColor.withOpacity(0.15) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentColor != null ? accentColor.withOpacity(0.3) : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: accentColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// 🔐 CLASS PRESERVED 100%
class Holiday {
  final int id;
  final String name;
  final DateTime date;
  final String type;

  Holiday({
    required this.id,
    required this.name,
    required this.date,
    required this.type,
  });
}