import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';

class LeaveStatusCard extends StatelessWidget {
  final Map leave;
  const LeaveStatusCard({super.key, required this.leave});

  Color getStatusColor(String status) {
    if (status == 'APPROVED') return const Color(0xFF10B981); // Sleek Emerald
    if (status == 'REJECTED') return const Color(0xFFEF4444); // Sleek Red
    return const Color(0xFFF59E0B); // Sleek Amber for Pending/Others
  }

  @override
  Widget build(BuildContext context) {
    final String statusText = leave['status'] ?? 'PENDING';
    final Color statusColor = getStatusColor(statusText);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03), // Extremely sheer background
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.08), // Ultra-thin crystal border
                width: 1,
              ),
            ),
            child: Row(
              children: [
                // 🟢 Icon Indicator
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.event_note_rounded,
                    size: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(width: 14),

                // 🟢 Leave Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${leave['leaveType']} Leave',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${leave['fromDate'].split("T")[0]} → ${leave['toDate'].split("T")[0]}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // 🟢 Glassmorphic Status Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15), // Tinted background
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: statusColor.withOpacity(0.3), // Tinted border
                      width: 1,
                    ),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}