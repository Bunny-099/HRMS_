import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';


class PerformanceHistoryScreen extends StatefulWidget {
  static const String id = 'performance_history_screen';
  
  const PerformanceHistoryScreen({super.key});

  @override
  State<PerformanceHistoryScreen> createState() => _PerformanceHistoryScreenState();
}

class _PerformanceHistoryScreenState extends State<PerformanceHistoryScreen> {
  // Sample performance history data
  List<PerformanceRecord> records = [
    PerformanceRecord(
      id: 1,
      period: 'Q4 2023',
      rating: 4.5,
      feedback: 'Excellent performance in sales targets',
      date: '2023-12-31',
      status: 'Completed',
    ),
    PerformanceRecord(
      id: 2,
      period: 'Q3 2023',
      rating: 4.2,
      feedback: 'Good performance, met all KPIs',
      date: '2023-09-30',
      status: 'Completed',
    ),
    PerformanceRecord(
      id: 3,
      period: 'Q2 2023',
      rating: 4.0,
      feedback: 'Satisfactory performance',
      date: '2023-06-30',
      status: 'Completed',
    ),
    PerformanceRecord(
      id: 4,
      period: 'Q1 2023',
      rating: 3.8,
      feedback: 'Performance needs improvement',
      date: '2023-03-31',
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Performance History',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Overall performance card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 24,
                  child: Column(
                    children: [
                      const Text(
                        'Overall Performance',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: GlassTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '4.1',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: Colors.amber,
                            size: 28,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Performance records list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return _buildPerformanceCard(record);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCard(PerformanceRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.period,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: GlassTheme.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: GlassTheme.success.withOpacity(0.2)),
                  ),
                  child: Text(
                    record.status,
                    style: const TextStyle(
                      fontSize: 11,
                      color: GlassTheme.successAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: Colors.amber,
                ),
                const SizedBox(width: 6),
                Text(
                  record.rating.toString(),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                record.feedback,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceRecord {
  final int id;
  final String period;
  final double rating;
  final String feedback;
  final String date;
  final String status;

  PerformanceRecord({
    required this.id,
    required this.period,
    required this.rating,
    required this.feedback,
    required this.date,
    required this.status,
  });
}
