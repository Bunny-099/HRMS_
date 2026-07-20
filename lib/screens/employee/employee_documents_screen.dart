import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

class EmployeeDocumentsScreen extends StatefulWidget {
  static const String id = 'employee_documents_screen';
  
  const EmployeeDocumentsScreen({super.key});

  @override
  State<EmployeeDocumentsScreen> createState() => _EmployeeDocumentsScreenState();
}

class _EmployeeDocumentsScreenState extends State<EmployeeDocumentsScreen> {
  // Sample documents data
  List<Document> documents = [
    Document(
      id: 1,
      name: 'ID Proof',
      type: 'PDF',
      status: 'Verified',
      date: '2023-01-15',
    ),
    Document(
      id: 2,
      name: 'Educational Certificates',
      type: 'PDF',
      status: 'Pending',
      date: '2023-02-20',
    ),
    Document(
      id: 3,
      name: 'Employment Contract',
      type: 'PDF',
      status: 'Verified',
      date: '2023-01-15',
    ),
    Document(
      id: 4,
      name: 'Tax Documents',
      type: 'PDF',
      status: 'Verified',
      date: '2023-01-20',
    ),
    Document(
      id: 5,
      name: 'Insurance Documents',
      type: 'PDF',
      status: 'Pending',
      date: '2023-03-10',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Employee Documents',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                const SizedBox(height: 20),
                // Documents list
                Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final document = documents[index];
                      return _buildDocumentCard(document);
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

  Widget _buildDocumentCard(Document document) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        borderRadius: 20,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Document icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: GlassTheme.errorAccent,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            
            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Type: ${document.type} | Date: ${document.date}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: GlassTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            
            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: (document.status == 'Verified' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (document.status == 'Verified' ? GlassTheme.success : GlassTheme.warning).withOpacity(0.2),
                ),
              ),
              child: Text(
                document.status,
                style: TextStyle(
                  fontSize: 11,
                  color: document.status == 'Verified' ? GlassTheme.successAccent : GlassTheme.warningAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Document {
  final int id;
  final String name;
  final String type;
  final String status;
  final String date;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.date,
  });
}
