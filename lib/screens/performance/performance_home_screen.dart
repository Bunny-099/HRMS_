import 'dart:ui'; // 🟢 ADDED: Required for Glassmorphic ImageFilter.blur
import 'package:flutter/material.dart';

import 'goals_kpi_screen.dart';
import 'feedback_rating_screen.dart';
import 'performance_history_screen.dart';

class PerformanceHomeScreen extends StatefulWidget {
  static const String id = 'performance_home_screen';

  const PerformanceHomeScreen({super.key});

  @override
  State<PerformanceHomeScreen> createState() => _PerformanceHomeScreenState();
}

class _PerformanceHomeScreenState extends State<PerformanceHomeScreen> {
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
                color: const Color(0xFF3B82F6).withOpacity(0.08), // Blue glow
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
                color: const Color(0xFF10B981).withOpacity(0.06), // Emerald glow
              ),
            ),
          ),

          // 3. Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Performance',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                      ),

                      // Assessment Icon
                      _buildGlassIconButton(
                        icon: Icons.assessment_rounded,
                        onTap: () {},
                        accentColor: const Color(0xFF3B82F6),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 🟢 Performance summary card (Frosted Glass)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.04),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Current Rating',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              '4.2',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF10B981), // Emerald glow for good rating
                                letterSpacing: -1.0,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Out of 5.0',
                              style: TextStyle(
                                fontSize: 14,
                                color: textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Quick Actions Title
                  const Text(
                    'Quick Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 🟢 Action buttons grid
                  Expanded(
                    child: GridView.count(
                      physics: const BouncingScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildActionCard(
                          icon: Icons.flag_rounded,
                          title: 'Goals & KPI',
                          subtitle: 'View targets',
                          color: const Color(0xFF3B82F6), // Blue
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const GoalsKpiScreen(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          icon: Icons.rate_review_rounded,
                          title: 'Feedback',
                          subtitle: 'View reviews',
                          color: const Color(0xFFF59E0B), // Amber
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const FeedbackRatingScreen(),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          icon: Icons.history_rounded,
                          title: 'History',
                          subtitle: 'View records',
                          color: const Color(0xFF8B5CF6), // Violet
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PerformanceHistoryScreen(),
                              ),
                            );
                          },
                        ),
                      ],
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

  // 🟢 Ultra-Minimal Frosted Glass Action Card
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.08),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color.withOpacity(0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, size: 28, color: color),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 0.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  textAlign: TextAlign.center,
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