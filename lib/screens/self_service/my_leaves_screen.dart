import 'package:flutter/material.dart';


class MyLeavesScreen extends StatefulWidget {
  static const String id = 'my_leaves_screen';
  
  const MyLeavesScreen({super.key});

  @override
  State<MyLeavesScreen> createState() => _MyLeavesScreenState();
}

class _MyLeavesScreenState extends State<MyLeavesScreen> {
  // Sample leave data
  List<LeaveRequest> leaveRequests = [
    LeaveRequest(
      id: 1,
      type: 'Casual Leave',
      startDate: '2024-01-15',
      endDate: '2024-01-17',
      days: 3,
      status: 'Approved',
      reason: 'Personal reasons',
      appliedDate: '2024-01-10',
      approvedBy: 'John Smith',
    ),
    LeaveRequest(
      id: 2,
      type: 'Sick Leave',
      startDate: '2024-01-20',
      endDate: '2024-01-22',
      days: 3,
      status: 'Pending',
      reason: 'Medical consultation',
      appliedDate: '2024-01-18',
      approvedBy: 'N/A',
    ),
    LeaveRequest(
      id: 3,
      type: 'Menstrual Wellness Leave',
      startDate: '2024-02-05',
      endDate: '2024-02-05',
      days: 1,
      status: 'Rejected',
      reason: 'Health reasons',
      appliedDate: '2024-01-25',
      approvedBy: 'John Smith',
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
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'My Leaves',
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
                      Icons.add,
                      size: 20,
                      color: Color(0xFFFF69B4),
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
                      title: 'Pending',
                      value: '1',
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Approved',
                      value: '1',
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Rejected',
                      value: '1',
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildSummaryCard(
                      title: 'Balance',
                      value: '12',
                      color: const Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Leave requests list
              Expanded(
                child: ListView.builder(
                  itemCount: leaveRequests.length,
                  itemBuilder: (context, index) {
                    final request = leaveRequests[index];
                    return _buildLeaveRequestCard(request);
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
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFFFF69B4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveRequestCard(LeaveRequest request) {
    Color statusColor = Colors.grey;
    if (request.status == 'Approved') statusColor = Colors.green;
    else if (request.status == 'Rejected') statusColor = Colors.red;
    else if (request.status == 'Pending') statusColor = Colors.orange;

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  request.type,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    request.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
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
                  Icons.calendar_today,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  '${request.startDate} to ${request.endDate}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  Icons.work,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  '${request.days} days',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  'Applied: ${request.appliedDate}',
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
                request.reason,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ),
            if (request.status != 'Pending') ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 14,
                    color: const Color(0xFFFF69B4),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Approved by: ${request.approvedBy}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LeaveRequest {
  final int id;
  final String type;
  final String startDate;
  final String endDate;
  final int days;
  final String status;
  final String reason;
  final String appliedDate;
  final String approvedBy;

  LeaveRequest({
    required this.id,
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.status,
    required this.reason,
    required this.appliedDate,
    required this.approvedBy,
  });
}