import 'package:flutter/material.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';


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
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Feedback & Rating',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.filter_list, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),
                // Average rating card
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  borderRadius: 24,
                  child: Column(
                    children: [
                      const Text(
                        'Average Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: GlassTheme.textMuted,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '4.4',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star_rounded : Icons.star_half_rounded,
                            color: Colors.amber,
                            size: 28,
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
                    physics: const BouncingScrollPhysics(),
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
      ),
    );
  }

  Widget _buildFeedbackCard(Feedback feedback) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 20,
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
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        feedback.reviewerRole,
                        style: const TextStyle(
                          fontSize: 13,
                          color: GlassTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: GlassTheme.accentGlow.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: GlassTheme.accentGlow.withOpacity(0.2)),
                  ),
                  child: Text(
                    feedback.type,
                    style: const TextStyle(
                      fontSize: 11,
                      color: GlassTheme.accentGlow,
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
                  feedback.category,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Colors.amber,
                ),
                const SizedBox(width: 4),
                Text(
                  feedback.rating.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: GlassTheme.textMuted,
                ),
                const SizedBox(width: 6),
                Text(
                  feedback.date,
                  style: const TextStyle(
                    fontSize: 12,
                    color: GlassTheme.textMuted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
              ),
              child: Text(
                feedback.feedback,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.4,
                  fontStyle: FontStyle.italic,
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
