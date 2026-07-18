import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';

class AnnouncementsScreen extends StatefulWidget {
  static const String id = 'announcements_screen';

  const AnnouncementsScreen({super.key});

  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  // 🔐 DATA PRESERVED 100%
  List<Announcement> announcements = [
    Announcement(
      id: 1,
      title: 'New Policy Implementation',
      content: 'A new HR policy has been implemented regarding work from home. All employees are required to read and acknowledge the policy.',
      date: '2024-01-15',
      priority: 'High',
      category: 'Policy',
      author: 'HR Department',
    ),
    Announcement(
      id: 2,
      title: 'Office Holiday Notice',
      content: 'The office will be closed on 26th January 2024 for Republic Day. All employees are requested to plan their work accordingly.',
      date: '2024-01-10',
      priority: 'Medium',
      category: 'Holiday',
      author: 'Admin Department',
    ),
    Announcement(
      id: 3,
      title: 'Team Building Event',
      content: 'A team building event is scheduled for 15th February 2024. All employees are encouraged to participate.',
      date: '2024-01-05',
      priority: 'Low',
      category: 'Event',
      author: 'Operations Team',
    ),
    Announcement(
      id: 4,
      title: 'System Maintenance',
      content: 'The payroll system will undergo maintenance on 20th January 2024. Payroll processing will resume on 21st January.',
      date: '2024-01-01',
      priority: 'High',
      category: 'IT',
      author: 'IT Department',
    ),
  ];

  // 🟢 Sleek Dark Glassmorphism Color Tokens (Synced across App)
  final Color bgDarkStart = const Color(0xFF090D16);
  final Color bgDarkEnd = const Color(0xFF111827);
  final Color textWhite = Colors.white;
  final Color textMuted = const Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgDarkStart,
      body: Stack(
        children: [
          // 1. Deep Midnight Ambient Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgDarkStart, bgDarkEnd, const Color(0xFF0A0F1D)],
              ),
            ),
          ),

          // 🟢 2. Subtle Ambient Glow Orbs for Glass Effect
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF3B82F6).withOpacity(0.08), // Sleek Blue
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -100,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.06), // Violet
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      _buildGlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () => Navigator.pop(context),
                      ),

                      // Title
                      const Text(
                        'Announcements',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),

                      // Notification Icon
                      _buildGlassIconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () {},
                        accentColor: const Color(0xFF3B82F6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Announcement list
                  Expanded(
                    child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: announcements.length,
                      itemBuilder: (context, index) {
                        final announcement = announcements[index];
                        return _buildAnnouncementCard(announcement);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🟢 Ultra-Minimal Frosted Glass Announcement Card
  Widget _buildAnnouncementCard(Announcement announcement) {
    Color priorityColor = const Color(0xFF94A3B8); // Default slate
    if (announcement.priority == 'High') {
      priorityColor = const Color(0xFFEF4444); // Red
    } else if (announcement.priority == 'Medium') {
      priorityColor = const Color(0xFFF59E0B); // Amber
    } else if (announcement.priority == 'Low') {
      priorityColor = const Color(0xFF10B981); // Emerald
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              // Slight tint of priority color mixed with white
              color: Colors.white.withOpacity(0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Small glowing dot for priority
                    Container(
                      margin: const EdgeInsets.only(top: 6, right: 12),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: priorityColor,
                        boxShadow: [
                          BoxShadow(
                            color: priorityColor.withOpacity(0.5),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        announcement.title,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    // Priority Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: priorityColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        announcement.priority,
                        style: TextStyle(
                          fontSize: 11,
                          color: priorityColor,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Content
                Text(
                  announcement.content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.75),
                    height: 1.5, // Better line height for readability
                  ),
                ),
                const SizedBox(height: 20),

                // Meta info footer
                Container(
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: Colors.white.withOpacity(0.05),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      // Category
                      Icon(Icons.folder_outlined, size: 14, color: textMuted),
                      const SizedBox(width: 4),
                      Text(
                        announcement.category,
                        style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),

                      // Author
                      Icon(Icons.person_outline_rounded, size: 14, color: textMuted),
                      const SizedBox(width: 4),
                      Text(
                        announcement.author,
                        style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(width: 12),

                      // Date
                      Icon(Icons.access_time_rounded, size: 14, color: textMuted),
                      const SizedBox(width: 4),
                      Text(
                        announcement.date,
                        style: TextStyle(fontSize: 12, color: textMuted, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper Widget for sleek glass buttons in Header
  Widget _buildGlassIconButton({required IconData icon, required VoidCallback onTap, Color? accentColor}) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: accentColor != null ? accentColor.withOpacity(0.15) : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: accentColor != null ? accentColor.withOpacity(0.3) : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Icon(
              icon,
              size: 20,
              color: accentColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// 🔐 CLASS STRUCTURE PRESERVED 100%
class Announcement {
  final int id;
  final String title;
  final String content;
  final String date;
  final String priority;
  final String category;
  final String author;

  Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    required this.priority,
    required this.category,
    required this.author,
  });
}