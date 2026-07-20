import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';


class GoalsKpiScreen extends StatefulWidget {
  static const String id = 'goals_kpi_screen';
  
  const GoalsKpiScreen({super.key});

  @override
  State<GoalsKpiScreen> createState() => _GoalsKpiScreenState();
}

class _GoalsKpiScreenState extends State<GoalsKpiScreen> {
  // Sample goals data
  List<Goal> goals = [
    Goal(
      id: 1,
      title: 'Increase Sales',
      description: 'Achieve 25% increase in sales this quarter',
      target: 100,
      current: 75,
      deadline: '2024-03-31',
      status: 'In Progress',
    ),
    Goal(
      id: 2,
      title: 'Complete Training',
      description: 'Finish leadership development course',
      target: 100,
      current: 90,
      deadline: '2024-02-28',
      status: 'In Progress',
    ),
    Goal(
      id: 3,
      title: 'Customer Satisfaction',
      description: 'Maintain 95% customer satisfaction score',
      target: 95,
      current: 92,
      deadline: '2024-03-31',
      status: 'In Progress',
    ),
    Goal(
      id: 4,
      title: 'Project Delivery',
      description: 'Deliver project on time with quality',
      target: 100,
      current: 100,
      deadline: '2024-01-15',
      status: 'Completed',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Goals & KPI',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.add, color: Colors.white),
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
                // Summary cards
                Row(
                  children: [
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Active Goals',
                        value: '3',
                        color: GlassTheme.accentGlow,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildSummaryCard(
                        title: 'Completed',
                        value: '1',
                        color: GlassTheme.success,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                _buildSummaryCard(
                  title: 'Avg. Progress',
                  value: '91%',
                  color: GlassTheme.warning,
                ),
                const SizedBox(height: 30),
                
                // Goals list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: goals.length,
                    itemBuilder: (context, index) {
                      final goal = goals[index];
                      return _buildGoalCard(goal);
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

  Widget _buildSummaryCard({required String title, required String value, required Color color}) {
    return GlassCard(
      padding: const EdgeInsets.all(15),
      borderRadius: 16,
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: GlassTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    double progress = (goal.current / goal.target) * 100;
    Color progressColor = GlassTheme.success;
    if (progress < 50) progressColor = GlassTheme.error;
    else if (progress < 80) progressColor = GlassTheme.warning;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    goal.title,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: goal.status == 'Completed' 
                        ? GlassTheme.success.withOpacity(0.15) 
                        : GlassTheme.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (goal.status == 'Completed' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    goal.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: goal.status == 'Completed' ? GlassTheme.successAccent : GlassTheme.warningAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              goal.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(
                  Icons.flag_rounded,
                  size: 16,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Target: ${goal.target}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.access_time_rounded,
                  size: 16,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  'Deadline: ${goal.deadline}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Progress bar
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(5),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth * (goal.current / goal.target),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [progressColor, progressColor.withOpacity(0.7)],
                          ),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: progressColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.current}%',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${(goal.current / goal.target * 100).toStringAsFixed(1)}% Complete',
                  style: TextStyle(
                    fontSize: 13,
                    color: progressColor.withOpacity(0.9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Goal {
  final int id;
  final String title;
  final String description;
  final double target;
  final double current;
  final String deadline;
  final String status;

  Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.target,
    required this.current,
    required this.deadline,
    required this.status,
  });
}
