import 'package:flutter/material.dart';


class FeedbackRatingScreen extends StatefulWidget {
  static const String id = 'feedback_rating_screen';
  
  const FeedbackRatingScreen({super.key});

  @override
  State<FeedbackRatingScreen> createState() => _FeedbackRatingScreenState();
}

class _FeedbackRatingScreenState extends State<FeedbackRatingScreen> {
  // Sample feedback data
  List<Feedback> feedbacks = [
    Feedback(
      id: 1,
      reviewer: 'Jane Smith',
      reviewerRole: 'Manager',
      rating: 4.5,
      category: 'Leadership',
      feedback: 'Excellent leadership skills, motivates team effectively.',
      date: '2023-12-15',
      type: 'Manager Review',
    ),
    Feedback(
      id: 2,
      reviewer: 'Robert Johnson',
      reviewerRole: 'Team Lead',
      rating: 4.2,
      category: 'Communication',
      feedback: 'Good communication skills, always clear and concise.',
      date: '2023-12-10',
      type: 'Peer Review',
    ),
    Feedback(
      id: 3,
      reviewer: 'Michael Wilson',
      reviewerRole: 'Colleague',
      rating: 4.8,
      category: 'Teamwork',
      feedback: 'Great team player, always ready to help others.',
      date: '2023-12-05',
      type: 'Peer Review',
    ),
    Feedback(
      id: 4,
      reviewer: 'Emily Davis',
      reviewerRole: 'HR Manager',
      rating: 4.0,
      category: 'Overall Performance',
      feedback: 'Consistent performer with good results.',
      date: '2023-11-30',
      type: 'HR Review',
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
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                  ),
                  Text(
                    'Feedback & Rating',
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
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      size: 20,
                      color: Color(0xFFFF69B4),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              
              // Average rating card
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
                      'Average Rating',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '4.4',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF69B4),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          index < 4 ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                        );
                      }),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              
              // Feedbacks list
              Expanded(
                child: ListView.builder(
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    final feedback = feedbacks[index];
                    return _buildFeedbackCard(feedback);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackCard(Feedback feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feedback.reviewer,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF69B4),
                        ),
                      ),
                      Text(
                        feedback.reviewerRole,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFFFF69B4),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF69B4).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    feedback.type,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFF69B4),
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
                  feedback.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
                const SizedBox(width: 15),
                Icon(
                  Icons.star,
                  size: 14,
                  color: Colors.orange,
                ),
                const SizedBox(width: 5),
                Text(
                  feedback.rating.toString(),
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
                  feedback.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFFF69B4),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFACD),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                feedback.feedback,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFF69B4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Feedback {
  final int id;
  final String reviewer;
  final String reviewerRole;
  final double rating;
  final String category;
  final String feedback;
  final String date;
  final String type;

  Feedback({
    required this.id,
    required this.reviewer,
    required this.reviewerRole,
    required this.rating,
    required this.category,
    required this.feedback,
    required this.date,
    required this.type,
  });
}