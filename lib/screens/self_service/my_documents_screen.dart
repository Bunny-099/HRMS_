import 'package:flutter/material.dart';


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
      backgroundColor: const Color(0xFFFFFACD),
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
                        color: const Color(0xFFFFFACD),
                        shape: BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFFFACD),
                            offset: Offset(-4, -4),
                            blurRadius: 8,
                          ),
                          BoxShadow(
                            color: Color(0xFFFF69B4),
                            offset: Offset(4, 4),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'My Documents',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFACD),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFFFFACD),
                          offset: Offset(-4, -4),
                          blurRadius: 8,
                        ),
                        BoxShadow(
                          color: Color(0xFFFF69B4),
                          offset: Offset(4, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.upload,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Summary card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFACD),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFFFFACD),
                      offset: Offset(-6, -6),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      color: Color(0xFFFF69B4),
                      offset: Offset(6, 6),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Document Status',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatusSummary('Verified', '4', Colors.green),
                        _buildStatusSummary('Pending', '1', Colors.orange),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Documents list
              Expanded(
                child: ListView.builder(
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
    );
  }

  Widget _buildStatusSummary(String title, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFFF69B4),
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentCard(Document document) {
    Color statusColor = Colors.grey;
    if (document.status == 'Verified') statusColor = Colors.green;
    else if (document.status == 'Pending') statusColor = Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFACD),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFFFFACD),
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Color(0xFFFF69B4),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
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
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    document.status,
                    style: TextStyle(
                      fontSize: 12,
                      color: statusColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.category,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  document.type,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: const Color(0xFFFF69B4),
                ),
                const SizedBox(width: 5),
                Text(
                  document.uploadDate,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF69B4).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFFF69B4),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF69B4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.visibility,
                    color: const Color(0xFFFFFACD),
                    size: 16,
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