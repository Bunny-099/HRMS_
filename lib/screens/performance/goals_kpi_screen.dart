import 'package:flutter/material.dart';


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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: const Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'Goals & KPI',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF69B4),
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 20,
                      color: const Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Summary cards
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Active Goals',
                      value: '3',
                      color: const Color(0xFFFF69B4),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Completed',
                      value: '1',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              _buildSummaryCard(
                title: 'Avg. Progress',
                value: '91%',
                color: Colors.orange,
              ),
              const SizedBox(height: 30),
              
              // Goals list
              Expanded(
                child: ListView.builder(
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
    );
  }

  Widget _buildSummaryCard({required String title, required String value, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
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
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: const Color(0xFFFF69B4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard(Goal goal) {
    double progress = (goal.current / goal.target) * 100;
    Color progressColor = Colors.green;
    if (progress < 50) progressColor = Colors.red;
    else if (progress < 80) progressColor = Colors.orange;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Container(
        padding: const EdgeInsets.all(15),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFFF69B4),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: goal.status == 'Completed' 
                        ? Colors.green.withValues(alpha: 0.2) 
                        : Colors.orange.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    goal.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: goal.status == 'Completed' ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              goal.description,
              style: const TextStyle(
                fontSize: 14,
                color: const Color(0xFFFF69B4),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.flag,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  'Target: ${goal.target}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFFF69B4),
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
                  'Deadline: ${goal.deadline}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFFF69B4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Progress bar
            Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth * (goal.current / goal.target),
                        decoration: BoxDecoration(
                          color: progressColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${goal.current}%',
                  style: const TextStyle(
                    fontSize: 12,
                    color: const Color(0xFFFF69B4),
                  ),
                ),
                Text(
                  '${(goal.current / goal.target * 100).toStringAsFixed(1)}% Complete',
                  style: TextStyle(
                    fontSize: 12,
                    color: progressColor,
                    fontWeight: FontWeight.w500,
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