import 'package:flutter/material.dart';
import 'package:hrms/widgets/soft_ui.dart';

class HolidayCalendarScreen extends StatefulWidget {
  static const String id = 'holiday_calendar_screen';
  
  const HolidayCalendarScreen({super.key});

  @override
  State<HolidayCalendarScreen> createState() => _HolidayCalendarScreenState();
}

class _HolidayCalendarScreenState extends State<HolidayCalendarScreen> {
  // Sample holiday data
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

  @override
  Widget build(BuildContext context) {
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
                    'Holiday Calendar',
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
                      Icons.calendar_today,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Holiday list
              Expanded(
                child: ListView.builder(
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
    );
  }

  Widget _buildHolidayCard(Holiday holiday) {
    String day = _getDayName(holiday.date.weekday);
    String month = _getMonthName(holiday.date.month);
    String dayNumber = holiday.date.day.toString();

    Color typeColor = Colors.blue;
    if (holiday.type == 'National Holiday') typeColor = Colors.green;
    else if (holiday.type == 'Religious Holiday') typeColor = Colors.purple;
    else if (holiday.type == 'Festival') typeColor = Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
            // Date circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: typeColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontSize: 10,
                      color: typeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    dayNumber,
                    style: TextStyle(
                      fontSize: 16,
                      color: typeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    month,
                    style: TextStyle(
                      fontSize: 10,
                      color: typeColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 15),
            // Holiday info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    holiday.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${holiday.date.day}/${holiday.date.month}/${holiday.date.year}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: typeColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      holiday.type,
                      style: TextStyle(
                        fontSize: 12,
                        color: typeColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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