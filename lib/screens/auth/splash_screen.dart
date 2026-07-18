import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hrms/screens/auth/login_screen.dart';
import 'package:hrms/screens/dashboards/admin/admin_dashboard.dart';
import 'package:hrms/screens/dashboards/employee/employee_dashboard.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';
  
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _textFade;

  bool _animationDone = false;
  bool _authDone = false;
  String _nextRoute = '/login';

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.6, curve: Curves.easeOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 0.5, curve: Curves.easeIn),
      ),
    );

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.9, curve: Curves.easeOut),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    _controller.forward().whenComplete(() {
      _animationDone = true;
      _navigateIfReady();
    });

    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final role = prefs.getString('role');

    if (!mounted) return;

    if (token != null && token.trim().isNotEmpty) {
      if (role?.toUpperCase() == 'ADMIN') {
        _nextRoute = '/admin-dashboard';
      } else {
        _nextRoute = '/employee-dashboard';
      }
    } else {
      _nextRoute = '/login';
    }
    _authDone = true;
    _navigateIfReady();
  }

  void _navigateIfReady() {
    if (!(_animationDone && _authDone && mounted)) return;

    Widget destination;
    switch (_nextRoute) {
      case '/admin-dashboard':
        destination = const AdminDashboard();
        break;
      case '/employee-dashboard':
        destination = const EmployeeDashboard();
        break;
      default:
        destination = const LoginScreen();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => destination),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _logoFade,
              child: ScaleTransition(
                scale: _logoScale,
                child: Image.asset(
                  'assets/images/app_logo/logo.jpeg',
                  height: 100,
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: _textFade,
              child: SlideTransition(
                position: _textSlide,
                child: const Text(
                  'E-Smart HR',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
