import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/services/leave_service.dart';
import 'package:hrms/services/holiday_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class EmployeeCalendarScreen extends StatefulWidget {
  const EmployeeCalendarScreen({super.key});

  @override
  State<EmployeeCalendarScreen> createState() => _EmployeeCalendarScreenState();
}

class _EmployeeCalendarScreenState extends State<EmployeeCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<dynamic>> _events = {};
  bool _loading = true;

  // Colors
  final Color bgDarkStart = const Color(0xFF090D16);
  final Color bgDarkEnd = const Color(0xFF111827);
  final Color textMuted = const Color(0xFF94A3B8);
  
  final Color colorPresent = const Color(0xFF10B981);
  final Color colorAbsent = const Color(0xFFEF4444);
  final Color colorLeave = const Color(0xFF3B82F6);
  final Color colorHoliday = const Color(0xFFF59E0B);
  final Color colorLate = const Color(0xFFF59E0B);

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _fetchCalendarData();
  }

  Future<void> _fetchCalendarData() async {
    setState(() => _loading = true);
    
    try {
      final Map<DateTime, List<dynamic>> newEvents = {};

      // Using the new unified endpoint recommended in Backend Requirements
      final response = await ApiService().get(
        '/employee/calendar-events?month=${_focusedDay.month}&year=${_focusedDay.year}'
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Handle Map structure based on requirement sample
        // { "events": { "2024-03-01": { ... } } } OR { "events": [ { "date": "...", ... } ] }
        final eventsData = data['events'];
        
        if (eventsData is Map) {
          eventsData.forEach((dateKey, eventValue) {
            DateTime date = DateTime.parse(dateKey);
            date = DateTime(date.year, date.month, date.day);
            newEvents[date] = [eventValue];
          });
        } else if (eventsData is List) {
          for (var event in eventsData) {
            if (event['date'] != null) {
              DateTime date = DateTime.parse(event['date']);
              date = DateTime(date.year, date.month, date.day);
              newEvents[date] ??= [];
              newEvents[date]!.add(event);
            }
          }
        }
      } else {
        // Fallback to legacy if unified endpoint is not exactly as named
        debugPrint('Unified endpoint failed, falling back to multiple services');
        await _fetchFallbackData(newEvents);
      }

      setState(() {
        _events = newEvents;
        _loading = false;
      });
    } catch (e) {
      debugPrint('Error fetching calendar data: $e');
      setState(() => _loading = false);
    }
  }

  Future<void> _fetchFallbackData(Map<DateTime, List<dynamic>> newEvents) async {
    // 1. Fetch Attendance
    final attendanceRes = await ApiService().get('/attendance/history');
    if (attendanceRes.statusCode == 200) {
      final data = jsonDecode(attendanceRes.body);
      final list = data['attendance'] as List;
      for (var item in list) {
        if (item['date'] != null) {
          DateTime date = DateFormat('yyyy-MM-dd').parse(item['date']);
          date = DateTime(date.year, date.month, date.day);
          newEvents[date] ??= [];
          newEvents[date]!.add({
            'type': 'ATTENDANCE',
            'status': item['status'],
            'checkIn': item['checkInTime'],
            'checkOut': item['checkOutTime'],
          });
        }
      }
    }

    // 2. Fetch Leaves
    final leaves = await LeaveService.getMyLeaves();
    for (var leave in leaves) {
      if (leave['fromDate'] != null) {
        DateTime start = DateTime.parse(leave['fromDate']);
        DateTime end = DateTime.parse(leave['toDate']);
        for (int i = 0; i <= end.difference(start).inDays; i++) {
          DateTime date = start.add(Duration(days: i));
          date = DateTime(date.year, date.month, date.day);
          newEvents[date] ??= [];
          newEvents[date]!.add({
            'type': 'LEAVE',
            'status': leave['status'],
            'leaveType': leave['leaveType'],
          });
        }
      }
    }
  }

  List<dynamic> _getEventsForDay(DateTime day) {
    return _events[DateTime(day.year, day.month, day.day)] ?? [];
  }

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
          
          // Ambient Glows
          Positioned(top: -100, right: -50, child: Container(width: 300, height: 300, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF3B82F6).withOpacity(0.08)))),
          Positioned(bottom: 50, left: -100, child: Container(width: 350, height: 350, decoration: BoxDecoration(shape: BoxShape.circle, color: const Color(0xFF10B981).withOpacity(0.06)))),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _buildCalendarCard(),
                        const SizedBox(height: 24),
                        _buildDetailsPanel(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_loading) 
            const Center(child: CircularProgressIndicator(color: Color(0xFF3B82F6))),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildGlassIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            'My Calendar',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          _buildGlassIconButton(
            icon: Icons.refresh_rounded,
            onTap: _fetchCalendarData,
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
              _fetchCalendarData();
            },
            eventLoader: _getEventsForDay,
            
            // Styling
            calendarStyle: CalendarStyle(
              defaultTextStyle: const TextStyle(color: Colors.white),
              weekendTextStyle: const TextStyle(color: Colors.white70),
              outsideTextStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              todayDecoration: BoxDecoration(
                color: const Color(0xFF3B82F6).withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.5)),
              ),
              selectedDecoration: const BoxDecoration(
                color: Color(0xFF3B82F6),
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Color(0xFF10B981),
                shape: BoxShape.circle,
              ),
              markersMaxCount: 4,
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
              rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
              weekendStyle: TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w600),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(3).map((e) {
                    final event = e as Map<String, dynamic>;
                    Color markerColor = Colors.grey;
                    if (event['type'] == 'ATTENDANCE') {
                      markerColor = event['status'].toString().toUpperCase() == 'PRESENT' ? colorPresent : colorAbsent;
                    } else if (event['type'] == 'LEAVE') {
                      markerColor = colorLeave;
                    } else if (event['type'] == 'HOLIDAY') {
                      markerColor = colorHoliday;
                    }
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: markerColor),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsPanel() {
    final events = _getEventsForDay(_selectedDay ?? _focusedDay);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateFormat('EEEE, MMMM d').format(_selectedDay ?? _focusedDay),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        const SizedBox(height: 16),
        if (events.isEmpty)
          _buildEmptyState()
        else
          ...events.map((e) => _buildEventCard(e)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Icon(Icons.event_busy_rounded, size: 40, color: textMuted.withOpacity(0.5)),
          const SizedBox(height: 12),
          Text('No events or records for this day', style: TextStyle(color: textMuted, fontSize: 14)),
        ],
      ),
    );
  }

  Widget _buildEventCard(dynamic e) {
    final event = e as Map<String, dynamic>;
    IconData icon = Icons.info_outline;
    String title = "Event";
    String subtitle = "";
    Color color = Colors.blue;
    String? status;

    if (event['type'] == 'ATTENDANCE') {
      title = "Attendance";
      status = event['status'];
      icon = Icons.access_time_rounded;
      color = status?.toUpperCase() == 'PRESENT' ? colorPresent : colorAbsent;
      subtitle = status?.toUpperCase() == 'PRESENT' 
        ? "In: ${event['checkIn'] != null ? DateFormat.jm().format(DateTime.parse(event['checkIn'])) : '--'} • Out: ${event['checkOut'] != null ? DateFormat.jm().format(DateTime.parse(event['checkOut'])) : '--'}"
        : "Marked as $status";
    } else if (event['type'] == 'LEAVE') {
      title = "Leave: ${event['leaveType']}";
      status = event['status'];
      icon = Icons.event_note_rounded;
      color = colorLeave;
      subtitle = "Status: $status";
    } else if (event['type'] == 'HOLIDAY') {
      title = event['name'];
      subtitle = "Public Holiday";
      icon = Icons.celebration_rounded;
      color = colorHoliday;
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
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: textMuted, fontSize: 12)),
                    ],
                  ),
                ),
                if (status != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
            child: Icon(icon, size: 20, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
