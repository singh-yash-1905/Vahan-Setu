import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vahan_setu/features/aduit_logs/presentation/pages/audit_logs_screen.dart';

import 'package:vahan_setu/features/dashboard/presentation/pages/dashboard_overview_tab.dart';

import '../../../../core/theme/app_colors.dart';

import '../../../auth/presentation/bloc/register_bloc.dart';
import '../../../auth/presentation/bloc/register_event.dart';
import '../../../auth/presentation/bloc/register_state.dart';
import '../../../auth/presentation/pages/login_screen.dart';

import '../widgets/admin_app_drawer.dart';
import '../widgets/admin_bottom_nav_bar.dart';

import '../../../expenses/presentation/pages/expenses_tab.dart';
import '../../../vehicles/presentation/pages/vehicles_tab.dart';
import '../../../taxes/presentation/pages/taxes_tab.dart';
import '../../../documents/presentation/pages/documents_tab.dart';
import '../../../tanker_reports/presentation/pages/tanker_reports_tab.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static const String _profileImageKey = 'admin_profile_image_path';

  int _currentIndex = 0;

  File? _profileImage;

  late final List<Widget> _bottomNavPages;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(FetchAdminProfile());

    _loadProfileImage();

    _bottomNavPages = [
      Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.menu_rounded),
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          title: const Text(
            'Fleet Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          elevation: 0,
        ),
        body: DashboardOverviewTab(onNavigate: _handleNavigation),
      ),

      const VehiclesTab(),

      const ExpensesTab(),
    ];
  }

  Future<void> _loadProfileImage() async {
    final prefs = await SharedPreferences.getInstance();

    final savedImagePath = prefs.getString(_profileImageKey);

    if (savedImagePath == null || savedImagePath.isEmpty) {
      return;
    }

    final imageFile = File(savedImagePath);

    if (!imageFile.existsSync()) {
      await prefs.remove(_profileImageKey);
      return;
    }

    if (!mounted) return;

    setState(() {
      _profileImage = imageFile;
    });
  }

  /// Handles navigation from:
  /// - Bottom navigation
  /// - Drawer
  /// - Dashboard analytics cards
  void _handleNavigation(int destinationIndex, {int? subFilterIndex}) {
    // Bottom navigation pages.
    if (destinationIndex < 3) {
      setState(() {
        _currentIndex = destinationIndex;
      });
      return;
    }

    Widget? page;

    switch (destinationIndex) {
      case 3:
        page = TaxesTab(initialFilterIndex: subFilterIndex ?? 0);
        break;

      case 4:
        page = DocumentsTab(initialTabIndex: subFilterIndex ?? 0);
        break;

      case 5:
        page = const TankerReportsTab();
        break;
      case 6: // ADDED THIS CASE
        page = const AuditLogsScreen();
        break;
    }

    if (page != null) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      return;
    }

    final imageFile = File(pickedFile.path);

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_profileImageKey, imageFile.path);

    if (!mounted) return;

    setState(() {
      _profileImage = imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.background,

        drawer: AdminAppDrawer(
          currentIndex: _currentIndex,
          onNavigate: _handleNavigation,
          profileImage: _profileImage,
          onPickImage: _pickImage,
        ),

        body: IndexedStack(index: _currentIndex, children: _bottomNavPages),

        bottomNavigationBar: AdminBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _handleNavigation,
        ),
      ),
    );
  }
}
