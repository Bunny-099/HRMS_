import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../services/leave_service.dart';
import 'apply_leave_screen.dart';

class MyLeavesScreen extends StatefulWidget {
  const MyLeavesScreen({super.key});

  @override
  State<MyLeavesScreen> createState() => _MyLeavesScreenState();
}

class _MyLeavesScreenState extends State<MyLeavesScreen> {
  bool isLoading = true;
  List<dynamic> leaves = [];

@override
void initState() {
  super.initState();
  print("🔥 REAL MyLeavesScreen OPENED");
  fetchLeaves();
}

  Future<void> fetchLeaves() async {
    try {
      final data = await LeaveService.getMyLeaves();
      setState(() {
        leaves = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  int _countStatus(String status) =>
      leaves.where((l) => l['status'] == status).length;

  Color _statusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFACD),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFACD),
        elevation: 0,
        title: const Text(
          'My Leaves',
          style: TextStyle(
            color: Color(0xFFFF69B4),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFFFF69B4)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ApplyLeaveScreen(),
                ),
              ).then((_) => fetchLeaves());
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSummaryCards(),
                Expanded(child: _buildLeaveList()),
              ],
            ),
    );
  }

  // ================= SUMMARY =================
  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              _summaryCard('Pending', _countStatus('PENDING'), Colors.orange),
              _summaryCard('Approved', _countStatus('APPROVED'), Colors.green),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _summaryCard('Rejected', _countStatus('REJECTED'), Colors.red),
              _summaryCard('Total', leaves.length, const Color(0xFFFF69B4)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(String title, int value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33FF69B4),
              blurRadius: 6,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ================= LIST =================
  Widget _buildLeaveList() {
    if (leaves.isEmpty) {
      return const Center(child: Text('No leaves found'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: leaves.length,
      itemBuilder: (context, index) {
        final leave = leaves[index];

        final from = DateFormat('dd MMM yyyy')
            .format(DateTime.parse(leave['fromDate']));
        final to = DateFormat('dd MMM yyyy')
            .format(DateTime.parse(leave['toDate']));
        final applied = DateFormat('dd MMM yyyy')
            .format(DateTime.parse(leave['createdAt']));

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x33FF69B4),
                blurRadius: 6,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    leave['leaveType'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _statusColor(leave['status']).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      leave['status'],
                      style: TextStyle(
                        fontSize: 12,
                        color: _statusColor(leave['status']),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Text('📅 $from → $to'),
              Text('🕒 Applied: $applied'),
              const SizedBox(height: 8),
              Text(
                leave['reason'] ?? '',
                style: const TextStyle(color: Colors.grey),
              ),

              if (leave['approvedBy'] != null) ...[
                const SizedBox(height: 8),
                const Text(
                  '👤 Approved by HR',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
