import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:hrms/theme/soft_theme.dart' as custom_theme;
import 'package:hrms/services/api_services.dart';
import 'package:url_launcher/url_launcher.dart';


class PayslipPdfDownloadScreen extends StatefulWidget {
  
  static const String id = 'payslip_pdf_download_screen';
  
  const PayslipPdfDownloadScreen({super.key});

  @override
  State<PayslipPdfDownloadScreen> createState() => _PayslipPdfDownloadScreenState();
}

class _PayslipPdfDownloadScreenState extends State<PayslipPdfDownloadScreen> {
  final ApiService _api = ApiService();
bool _loading = false;

  // Sample months data
  List<MonthYear> months = [
    MonthYear(month: 'December', year: '2023', status: 'Available'),
    MonthYear(month: 'November', year: '2023', status: 'Available'),
    MonthYear(month: 'October', year: '2023', status: 'Available'),
    MonthYear(month: 'September', year: '2023', status: 'Available'),
    MonthYear(month: 'August', year: '2023', status: 'Available'),
    MonthYear(month: 'July', year: '2023', status: 'Available'),
    MonthYear(month: 'June', year: '2023', status: 'Available'),
    MonthYear(month: 'May', year: '2023', status: 'Available'),
    MonthYear(month: 'April', year: '2023', status: 'Available'),
    MonthYear(month: 'March', year: '2023', status: 'Available'),
    MonthYear(month: 'February', year: '2023', status: 'Available'),
    MonthYear(month: 'January', year: '2023', status: 'Available'),
  ];
int _monthToNumber(String month) {
  const months = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  return months[month] ?? 1;
}
Future<void> _downloadPayslip(String month, String year) async {
  try {
    setState(() => _loading = true);

    final monthNumber = _monthToNumber(month);

    // 1️⃣ Generate payslip
    final generateRes = await _api.get(
      '/payslips/generate?month=$monthNumber&year=$year',
    );

    if (generateRes.statusCode != 200 &&
        generateRes.statusCode != 201) {
      throw Exception('Failed to generate payslip');
    }

    final generateData = jsonDecode(generateRes.body);
    final payslipId = generateData['payslipId'];

    // 2️⃣ Get token
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('User not authenticated');
    }

    // 3️⃣ Download PDF with AUTH
    final pdfResponse = await _api.rawGet(
      '/payslips/$payslipId/pdf',
    );

    // 4️⃣ Save file
    final dir = await getApplicationDocumentsDirectory();
  final safeMonth = month; // already a String
final safeYear = year;

final file = File(
  '${dir.path}/payslip_${safeMonth}_$safeYear.pdf',
);

    await file.writeAsBytes(pdfResponse.bodyBytes);

    // 5️⃣ Open PDF
    await OpenFilex.open(file.path);

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
        backgroundColor: Colors.red,
      ),
    );
  } finally {
    setState(() => _loading = false);
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: custom_theme.SoftTheme.backgroundColor,
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
                        color: custom_theme.SoftTheme.cardColor,
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                            offset: Offset(-3, -3),
                            blurRadius: 5,
                          ),
                          BoxShadow(
                            color: Color(0xFFA3B1C6),
                            offset: Offset(3, 3),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                      ),
                    ),
                  ),
                  Text(
                    'Download Payslip',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: custom_theme.SoftTheme.textColor,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: custom_theme.SoftTheme.cardColor,
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-3, -3),
                          blurRadius: 5,
                        ),
                        BoxShadow(
                          color: Color(0xFFA3B1C6),
                          offset: Offset(3, 3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.refresh,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Info card
              SoftCard(
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: custom_theme.SoftTheme.hintColor,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Download your payslips in PDF format for the past 12 months',
                        style: TextStyle(
                          fontSize: 14,
                          color: custom_theme.SoftTheme.hintColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Month selector
              Text(
                'Select Month & Year',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: custom_theme.SoftTheme.textColor,
                ),
              ),
              const SizedBox(height: 20),
              
              // Months list
              Expanded(
                child: ListView.builder(
                  itemCount: months.length,
                  itemBuilder: (context, index) {
                    final month = months[index];
                    return _buildMonthCard(month);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMonthCard(MonthYear month) {
    bool isAvailable = month.status == 'Available';
    
    return SoftCard(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  month.month,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: custom_theme.SoftTheme.textColor,
                  ),
                ),
                Text(
                  month.year,
                  style: TextStyle(
                    fontSize: 14,
                    color: custom_theme.SoftTheme.hintColor,
                  ),
                ),
              ],
            ),
            if (isAvailable)
              Container(
                decoration: BoxDecoration(
                  color: custom_theme.SoftTheme.primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(-3, -3),
                      blurRadius: 5,
                    ),
                    BoxShadow(
                      color: Color(0xFFA3B1C6),
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => _downloadPayslip(month.month, month.year),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.download,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'Download',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Not Available',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class MonthYear {
  final String month;
  final String year;
  final String status; // 'Available' or 'Not Available'

  MonthYear({
    required this.month,
    required this.year,
    required this.status,
  });
}