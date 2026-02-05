import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:hrms/models/payslip_model.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/widgets/soft_ui.dart';
import 'package:hrms/theme/soft_theme.dart';

class PayslipPdfDownloadScreen extends StatefulWidget {
  static const String id = 'payslip_pdf_download_screen';

  final Payslip payslip;

  const PayslipPdfDownloadScreen({
    super.key,
    required this.payslip,
  });

  @override
  State<PayslipPdfDownloadScreen> createState() =>
      _PayslipPdfDownloadScreenState();
}

class _PayslipPdfDownloadScreenState
    extends State<PayslipPdfDownloadScreen> {
  final ApiService _api = ApiService();

  bool _downloading = false;
  String? _error;

  // ================= DOWNLOAD LOGIC =================

  Future<void> _downloadPayslipPdf() async {
    try {
      setState(() {
        _downloading = true;
        _error = null;
      });

      final response = await _api.rawGet(
        '/payslips/${widget.payslip.id}/pdf',
      );

      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/payslip_${widget.payslip.month}_${widget.payslip.year}.pdf',
      );

      await file.writeAsBytes(response.bodyBytes);
      await OpenFilex.open(file.path);
    } catch (e) {
      setState(() {
        _error = 'Failed to download payslip PDF';
      });
    } finally {
      setState(() {
        _downloading = false;
      });
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SoftTheme.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 30),

              if (_error != null) _buildError(),

              _buildPayslipInfo(),
              const SizedBox(height: 30),

              _buildDownloadSection(),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SoftCard(
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back),
            ),
          ),
        ),
        Text(
          'Payslip PDF',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: SoftTheme.textColor,
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  // ================= ERROR =================

  Widget _buildError() {
    return SoftCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error, color: Colors.red),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _error!,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= PAYSLIP INFO =================

  Widget _buildPayslipInfo() {
    final p = widget.payslip;

    return SoftCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Employee', p.employeeName),
          _infoRow('Employee ID', p.employeeId),
          const Divider(),
          _infoRow('Month', '${p.month} ${p.year}'),
          _infoRow(
            'Net Salary',
            '₹${p.netSalary.toStringAsFixed(0)}',
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: SoftTheme.hintColor,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: SoftTheme.textColor,
            ),
          ),
        ],
      ),
    );
  }

  // ================= DOWNLOAD =================

  Widget _buildDownloadSection() {
    return SoftCard(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(
              Icons.picture_as_pdf,
              size: 40,
              color: Colors.red,
            ),
            const SizedBox(height: 15),
            Text(
              'Download Payslip PDF',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: SoftTheme.textColor,
              ),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _downloading ? null : _downloadPayslipPdf,
                icon: _downloading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.download),
                label: Text(
                  _downloading ? 'Downloading...' : 'Download PDF',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
