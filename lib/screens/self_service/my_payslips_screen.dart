import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

class MyPayslipsScreen extends StatefulWidget {
  static const String id = 'my_payslips_screen';
  
  const MyPayslipsScreen({super.key});

  @override
  State<MyPayslipsScreen> createState() => _MyPayslipsScreenState();
}

class _MyPayslipsScreenState extends State<MyPayslipsScreen> {
  // Sample payslips data
  List<Payslip> payslips = [
    Payslip(
      id: 1,
      month: 'December',
      year: '2023',
      amount: 42300,
      status: 'Paid',
      issueDate: '2023-12-31',
      downloadUrl: 'https://example.com/payslip1.pdf',
    ),
    Payslip(
      id: 2,
      month: 'November',
      year: '2023',
      amount: 41800,
      status: 'Paid',
      issueDate: '2023-11-30',
      downloadUrl: 'https://example.com/payslip2.pdf',
    ),
    Payslip(
      id: 3,
      month: 'October',
      year: '2023',
      amount: 42000,
      status: 'Paid',
      issueDate: '2023-10-31',
      downloadUrl: 'https://example.com/payslip3.pdf',
    ),
    Payslip(
      id: 4,
      month: 'September',
      year: '2023',
      amount: 41500,
      status: 'Paid',
      issueDate: '2023-09-30',
      downloadUrl: 'https://example.com/payslip4.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'My Payslips',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.download_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Summary card
                GlassCard(
                  borderRadius: 24,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Total Earnings',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: GlassTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '₹1,67,600',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Last 4 months',
                        style: TextStyle(
                          fontSize: 13,
                          color: GlassTheme.accentGlow.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                // Payslips list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: payslips.length,
                    itemBuilder: (context, index) {
                      final payslip = payslips[index];
                      return _buildPayslipCard(payslip);
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

  Widget _buildPayslipCard(Payslip payslip) {
    Color statusColor = GlassTheme.successAccent;
    if (payslip.status == 'Pending') statusColor = GlassTheme.warningAccent;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${payslip.month} ${payslip.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: statusColor.withOpacity(0.2)),
                  ),
                  child: Text(
                    payslip.status,
                    style: TextStyle(
                      fontSize: 11,
                      color: statusColor,
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
                  Icons.payments_rounded,
                  size: 16,
                  color: GlassTheme.successAccent,
                ),
                const SizedBox(width: 6),
                Text(
                  '₹${payslip.amount.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  payslip.issueDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.1)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.file_download_rounded, size: 18, color: Colors.white70),
                          SizedBox(width: 8),
                          Text(
                            'Download PDF',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: GlassTheme.accentGlow,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: GlassTheme.accentGlow.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.visibility_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
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

class Payslip {
  final int id;
  final String month;
  final String year;
  final double amount;
  final String status;
  final String issueDate;
  final String downloadUrl;

  Payslip({
    required this.id,
    required this.month,
    required this.year,
    required this.amount,
    required this.status,
    required this.issueDate,
    required this.downloadUrl,
  });
}
