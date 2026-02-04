import 'package:flutter/material.dart';

class LeaveStatusCard extends StatelessWidget {
  final Map leave;
  const LeaveStatusCard({super.key, required this.leave});

  Color getStatusColor(String status) {
    if (status == 'APPROVED') return Colors.green;
    if (status == 'REJECTED') return Colors.red;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text('${leave['leaveType']} Leave'),
        subtitle: Text(
'${leave['fromDate'].split("T")[0]} → ${leave['toDate'].split("T")[0]}',

        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: getStatusColor(leave['status']),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            leave['status'],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
