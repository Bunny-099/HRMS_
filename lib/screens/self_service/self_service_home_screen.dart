import 'package:flutter/material.dart';
import 'package:hrms/screens/leave/my_leaves_screen.dart';
import 'package:hrms/theme/glass_theme.dart';
import 'package:hrms/widgets/glass_ui.dart';
import 'my_profile_screen.dart';
import 'my_documents_screen.dart';
import 'my_payslips_screen.dart';

class SelfServiceHomeScreen extends StatefulWidget {
  static const String id = 'self_service_home_screen';
  
  const SelfServiceHomeScreen({super.key});

  @override
  State<SelfServiceHomeScreen> createState() => _SelfServiceHomeScreenState();
}

class _SelfServiceHomeScreenState extends State<SelfServiceHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: const GlassAppBar(
        title: 'Self Service',
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.person_pin_rounded, color: Colors.white),
          ),
        ],
      ),
      body: GlassBackground(
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                
                // Action buttons grid
                Expanded(
                  child: GridView.count(
                    physics: const BouncingScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.0,
                    children: [
                      _buildActionCard(
                        icon: Icons.person_rounded,
                        title: 'My Profile',
                        subtitle: 'Personal details',
                        color: Colors.blueAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.folder_shared_rounded,
                        title: 'My Documents',
                        subtitle: 'View & download',
                        color: Colors.purpleAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyDocumentsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.payments_rounded,
                        title: 'My Payslips',
                        subtitle: 'Salary history',
                        color: GlassTheme.successAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyPayslipsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildActionCard(
                        icon: Icons.event_available_rounded,
                        title: 'My Leaves',
                        subtitle: 'Track requests',
                        color: Colors.orangeAccent,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyLeavesScreen(),
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
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        borderRadius: 24,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
