import 'package:flutter/material.dart';
import 'package:hrms/widgets/soft_ui.dart';

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
                        shape: BoxShape.circle,
                        color: const Color(0xFFE0E5EC),
                        boxShadow: const [
                          BoxShadow(
                            color: const Color(0xFFFFFACD),
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
                    'Employee Documents',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6572),
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE0E5EC),
                      boxShadow: const [
                        BoxShadow(
                          color: const Color(0xFFFFFACD),
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
                      Icons.add,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
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

  Widget _buildDocumentCard(Document document) {
    return SoftCard(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            // Document icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE0E5EC),
                boxShadow: const [
                  BoxShadow(
                    color: const Color(0xFFFFFACD),
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
                Icons.picture_as_pdf,
                color: Colors.red,
              ),
            ),
            const SizedBox(width: 15),
            
            // Document info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6572),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Type: ${document.type} | Date: ${document.date}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF78909C),
                    ),
                  ),
                ],
              ),
            ),
            
            // Status indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: document.status == 'Verified' 
                    ? Colors.green.withOpacity(0.2) 
                    : Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                document.status,
                style: TextStyle(
                  fontSize: 12,
                  color: document.status == 'Verified' ? Colors.green : Colors.orange,
                  fontWeight: FontWeight.w500,
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