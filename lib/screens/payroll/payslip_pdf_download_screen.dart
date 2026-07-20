import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:hrms/models/payslip_model.dart';
import 'package:hrms/services/api_services.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

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

  Future<void> _downloadPayslipPdf() async {
    try {
      setState(() {
        _downloading = true;
        _error = null;
      });

      final response = await _api.rawGet(
        '/payslips/pdf?month=${widget.payslip.month}&year=${widget.payslip.year}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(title: 'Payslip PDF'),
      body: GlassBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),

                if (_error != null) _buildError(),

                _buildPayslipInfo(),
                const SizedBox(height: 24),

                _buildDownloadSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: GlassCard(
        borderRadius: 16,
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.error_outline_rounded, color: GlassTheme.errorAccent),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _error!,
                style: const TextStyle(color: GlassTheme.errorAccent, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayslipInfo() {
    final p = widget.payslip;

    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoRow('Employee', p.employeeName),
          const SizedBox(height: 12),
          Divider(color: Colors.white.withOpacity(0.05)),
          const SizedBox(height: 12),
          _infoRow('Month', '${p.month} ${p.year}'),
          const SizedBox(height: 12),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: GlassTheme.textMuted,
            fontSize: 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: isBold ? GlassTheme.successAccent : Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildDownloadSection() {
    return GlassCard(
      borderRadius: 24,
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: GlassTheme.errorAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              size: 48,
              color: GlassTheme.errorAccent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Download Payslip PDF',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Save a secure copy to your device',
            style: TextStyle(
              fontSize: 13,
              color: GlassTheme.textMuted,
            ),
          ),
          const SizedBox(height: 32),
          GlassButton(
            text: _downloading ? 'Downloading...' : 'Download PDF',
            onTap: _downloading ? null : _downloadPayslipPdf,
          ),
        ],
      ),
    );
  }
}
