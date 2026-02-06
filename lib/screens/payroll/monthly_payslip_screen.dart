import 'package:flutter/material.dart';
import 'package:hrms/theme/soft_theme.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'payslip_pdf_download_screen.dart';
import 'dart:convert';
import 'package:hrms/models/payslip_model.dart';
import 'package:hrms/services/api_services.dart';

class MonthlyPayslipScreen extends StatefulWidget {
  static const String id = 'monthly_payslip_screen';

  const MonthlyPayslipScreen({super.key});

  @override
  State<MonthlyPayslipScreen> createState() => _MonthlyPayslipScreenState();
}

class _MonthlyPayslipScreenState extends State<MonthlyPayslipScreen> {
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _fetchPayslip();
  }

  Future<void> _fetchPayslip() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await _api.get(
        '/payslips/me?month=$selectedMonth&year=$selectedYear',
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          payslip = Payslip.fromJson(data);
          _loading = false;
        });
      } else {
        setState(() {
          _error = 'Payslip not found';
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to load payslip';
        _loading = false;
      });
    }
  }

  final ApiService _api = ApiService();
  Payslip? payslip;
  bool _loading = true;
  String? _error;

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(body: Center(child: Text(_error!)));
    }

    return Scaffold(
      backgroundColor: SoftTheme.backgroundColor,
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
                    child: SoftCard(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(Icons.arrow_back, size: 20),
                      ),
                    ),
                  ),
                  Text(
                    'Monthly Payslip',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SoftTheme.textColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PayslipPdfDownloadScreen(payslip: payslip!),
                        ),
                      );
                    },
                    child: SoftCard(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(Icons.download, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Payslip header
              SoftCard(
                child: Column(
                  children: [
                    Text(
                      'Payslip for $selectedMonth / $selectedYear',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: SoftTheme.textColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Employee: ${payslip!.employeeName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: SoftTheme.hintColor,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Earnings section
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _fetchPayslip,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),

                    child: Column(
                      children: [
                        _buildSectionHeader('Attendance', Colors.blue),

                        _buildPayslipRow(
                          'Present Days',
                          payslip!.attendance.presentDays.toDouble(),
                        ),
                        _buildPayslipRow(
                          'Leave Days',
                          payslip!.attendance.leaveDays.toDouble(),
                        ),
                        _buildPayslipRow(
                          'LOP Days',
                          payslip!.attendance.lopDays.toDouble(),
                        ),

                        const SizedBox(height: 20),
                        _buildSectionHeader('Earnings', Colors.green),

                        _buildPayslipRow(
                          'Basic Salary',
                          payslip!.earnings.basic,
                        ),
                        _buildPayslipRow('HRA', payslip!.earnings.hra),
                        _buildPayslipRow(
                          'Allowances',
                          payslip!.earnings.allowances,
                        ),

                        const SizedBox(height: 20),

                        _buildSectionHeader('Deductions', Colors.red),

                        _buildPayslipRow(
                          'LOP Deduction',
                          payslip!.deductions.lop,
                        ),

                        // Net salary
                        SoftCard(
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Net Salary',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: SoftTheme.textColor,
                                  ),
                                ),
                                Text(
                                  '₹${payslip!.netSalary.toStringAsFixed(0)}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: SoftTheme.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayslipRow(String label, double amount) {
    return SoftCard(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: SoftTheme.textColor),
            ),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: TextStyle(fontSize: 14, color: SoftTheme.textColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double amount) {
    return SoftCard(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: SoftTheme.primaryColor,
              ),
            ),
            Text(
              '₹${amount.toStringAsFixed(0)}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: SoftTheme.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
