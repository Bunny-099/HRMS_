import 'package:flutter/material.dart';
import 'package:hrms/theme/soft_theme.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'salary_structure_screen.dart';
import 'monthly_payslip_screen.dart';
import 'payslip_pdf_download_screen.dart';

class PayrollHomeScreen extends StatefulWidget {
  static const String id = 'payroll_home_screen';
  
  const PayrollHomeScreen({super.key});

  @override
  State<PayrollHomeScreen> createState() => _PayrollHomeScreenState();
}

class _PayrollHomeScreenState extends State<PayrollHomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                    child: SoftCard(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'Payroll',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: SoftTheme.textColor,
                    ),
                  ),
                  SoftCard(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.account_balance,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Payroll summary card
              SoftCard(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Current Month',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: SoftTheme.hintColor,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Rs. 45,000',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: SoftTheme.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Net Salary',
                        style: TextStyle(
                          fontSize: 14,
                          color: SoftTheme.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              
              // Quick Actions
              Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: SoftTheme.textColor,
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
                      icon: Icons.account_balance_wallet,
                      title: 'Salary Structure',
                      subtitle: 'View components',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SalaryStructureScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.receipt,
                      title: 'Monthly Payslip',
                      subtitle: 'View details',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MonthlyPayslipScreen(),
                          ),
                        );
                      },
                    ),
                    _buildActionCard(
                      icon: Icons.download,
                      title: 'Download Payslip',
                      subtitle: 'PDF format',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PayslipPdfDownloadScreen(),
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
    return SoftCard(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: SoftTheme.primaryColor,
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: SoftTheme.textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: SoftTheme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}