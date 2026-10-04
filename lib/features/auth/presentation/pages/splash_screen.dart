import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vahan_setu/features/auth/presentation/widgets/splash_background.dart';
import 'package:vahan_setu/features/auth/presentation/widgets/splash_content.dart';

import '../../../dashboard/presentation/pages/admin_dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Keep splash screen visible for 4  seconds
    await Future.delayed(const Duration(milliseconds: 4000));

    if (!mounted) return;

    const storage = FlutterSecureStorage();

    // Check if access token exists
    final token = await storage.read(key: 'auth_token');

    if (!mounted) return;

    if (token != null && token.isNotEmpty) {
      // User is already logged in -> Navigate to bottom navigation host screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardScreen()),
      );
    } else {
      // User is not logged in -> Navigate to login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(children: [SplashBackground(), SplashContent()]),
    );
  }
}
