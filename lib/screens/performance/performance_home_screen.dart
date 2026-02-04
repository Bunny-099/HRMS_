import 'package:flutter/material.dart';


import 'goals_kpi_screen.dart';
import 'feedback_rating_screen.dart';
import 'performance_history_screen.dart';

class PerformanceHomeScreen extends StatefulWidget {
  static const String id = 'performance_home_screen';
  
  const PerformanceHomeScreen({super.key});

  @override
  State<PerformanceHomeScreen> createState() => _PerformanceHomeScreenState();
}

class _PerformanceHomeScreenState extends State<PerformanceHomeScreen> {
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
                  Image.asset(
                    'assets/images/app_logo/logo.jpeg',
                    width: 30,
                    height: 30,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 15),
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
                            color: const Color(0xFFFFFACD),
                            offset: Offset(-4, -4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: const Color(0xFFFF69B4),
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
                    'Performance',
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
                          color: const Color(0xFFFFFACD),
                          offset: Offset(-4, -4),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: const Color(0xFFFF69B4),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.assessment,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Performance summary card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFACD),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: const Color(0xFFFFFACD),
                      offset: Offset(-6, -6),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: const Color(0xFFFF69B4),
                      offset: Offset(6, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Current Rating',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '4.2',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Out of 5.0',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 20),
              
              // Action buttons grid
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.0,
                  children: [
                    _buildActionCard(
                      icon: Icons.flag,
                      title: 'Goals & KPI',
                      subtitle: 'View targets',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GoalsKpiScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.rate_review,
                      title: 'Feedback & Rating',
                      subtitle: 'View reviews',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FeedbackRatingScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.history,
                      title: 'Performance History',
                      subtitle: 'View records',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PerformanceHistoryScreen(),
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
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFACD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: const Color(0xFFFFFACD),
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: const Color(0xFFFF69B4),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFFFF69B4),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFF69B4),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}