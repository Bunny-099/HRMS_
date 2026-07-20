import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';

class MyDocumentsScreen extends StatefulWidget {
  static const String id = 'my_documents_screen';
  
  const MyDocumentsScreen({super.key});

  @override
  State<MyDocumentsScreen> createState() => _MyDocumentsScreenState();
}

class _MyDocumentsScreenState extends State<MyDocumentsScreen> {
  // Sample documents data
  List<Document> documents = [
    Document(
      id: 1,
      name: 'Employee ID Card',
      type: 'ID Proof',
      status: 'Verified',
      uploadDate: '2023-01-15',
      downloadUrl: 'https://example.com/document1.pdf',
    ),
    Document(
      id: 2,
      name: 'Resume',
      type: 'Resume',
      status: 'Verified',
      uploadDate: '2023-01-10',
      downloadUrl: 'https://example.com/document2.pdf',
    ),
    Document(
      id: 3,
      name: 'Tax Documents',
      type: 'Tax',
      status: 'Verified',
      uploadDate: '2023-02-20',
      downloadUrl: 'https://example.com/document3.pdf',
    ),
    Document(
      id: 4,
      name: 'Contract',
      type: 'Contract',
      status: 'Verified',
      uploadDate: '2023-01-25',
      downloadUrl: 'https://example.com/document4.pdf',
    ),
    Document(
      id: 5,
      name: 'Certificates',
      type: 'Education',
      status: 'Pending',
      uploadDate: '2023-03-01',
      downloadUrl: 'https://example.com/document5.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'My Documents',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.file_upload_outlined, color: Colors.white),
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
                        'Document Status',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: GlassTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatusSummary('Verified', '4', GlassTheme.successAccent),
                          _buildStatusSummary('Pending', '1', GlassTheme.warningAccent),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
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

  Widget _buildStatusSummary(String title, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            color: GlassTheme.textMuted,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(Document document) {
    Color statusColor = GlassTheme.textMuted;
    if (document.status == 'Verified') statusColor = GlassTheme.successAccent;
    else if (document.status == 'Pending') statusColor = GlassTheme.warningAccent;

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
                Expanded(
                  child: Text(
                    document.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
                    document.status,
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
                  Icons.category_outlined,
                  size: 16,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  document.type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 20),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  document.uploadDate,
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
                            'Download',
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

class Document {
  final int id;
  final String name;
  final String type;
  final String status;
  final String uploadDate;
  final String downloadUrl;

  Document({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
    required this.uploadDate,
    required this.downloadUrl,
  });
}
