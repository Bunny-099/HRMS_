import 'package:flutter/material.dart';


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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'Performance History',
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Average rating card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFACD),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFFFFACD),
                      offset: Offset(-6, -6),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Color(0xFFFF69B4),
                      offset: Offset(6, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Overall Performance',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '4.1',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_border,
                          color: Colors.orange,
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
    );
  }

  Widget _buildPerformanceCard(PerformanceRecord record) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFACD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFFACD),
            offset: Offset(-6, -6),
            blurRadius: 10,
          ),
          BoxShadow(
            color: Color(0xFFFF69B4),
            offset: Offset(6, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  record.period,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    record.status,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.orange,
                ),
                const SizedBox(width: 5),
                Text(
                  record.rating.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  record.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFACD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                record.feedback,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF69B4),
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