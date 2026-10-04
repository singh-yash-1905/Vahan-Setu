import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vahan_setu/core/repository/audit_log_repo/audit_log_repository.dart';
import 'package:vahan_setu/core/repository/auth_repo/register_repository.dart';
import 'package:vahan_setu/core/repository/dashboard_repo/dashboard_repository.dart';
import 'package:vahan_setu/core/repository/doc_repo/document_repository.dart';
import 'package:vahan_setu/core/repository/expense_repo/expense_repository.dart';
import 'package:vahan_setu/core/repository/tanker_repo/tanker_report_repository.dart';
import 'package:vahan_setu/core/repository/tax_repo/tax_repository.dart';
import 'package:vahan_setu/core/repository/vehicle_repo/vehicle_repository.dart';
import 'package:vahan_setu/features/aduit_logs/presentation/bloc/audit_log_bloc.dart';

import 'core/network/custom_http_client.dart';
import 'core/theme/app_colors.dart';

// BLoCs
import 'features/auth/presentation/bloc/register_bloc.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'features/taxes/presentation/bloc/tax_bloc.dart';
import 'features/vehicles/presentation/bloc/vehicle_bloc.dart';
import 'features/documents/presentation/bloc/document_bloc.dart';
import 'features/tanker_reports/presentation/bloc/tanker_report_bloc.dart';
import 'features/expenses/presentation/bloc/expense_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const VahanSetuApp());
}

class VahanSetuApp extends StatelessWidget {
  const VahanSetuApp({super.key});

  @override
  Widget build(BuildContext context) {
    final httpClient = CustomHttpClient();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<VehicleRepository>(
          create: (_) => VehicleRepository(httpClient),
        ),
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(httpClient),
        ),
        RepositoryProvider<DashboardRepository>(
          create: (_) => DashboardRepository(httpClient),
        ),
        RepositoryProvider<TaxRepository>(
          create: (_) => TaxRepository(httpClient),
        ),
        RepositoryProvider<DocumentRepository>(
          create: (_) => DocumentRepository(httpClient),
        ),
        RepositoryProvider<TankerReportRepository>(
          create: (_) => TankerReportRepository(httpClient),
        ),
        RepositoryProvider<ExpenseRepository>(
          create: (_) => ExpenseRepository(httpClient),
        ),
        RepositoryProvider<AuditLogRepository>(
          create: (_) => AuditLogRepository(httpClient),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(context.read<AuthRepository>()),
          ),
          BlocProvider<VehicleBloc>(
            create: (context) => VehicleBloc(context.read<VehicleRepository>()),
          ),
          BlocProvider<DashboardBloc>(
            create: (context) =>
                DashboardBloc(context.read<DashboardRepository>()),
          ),
          BlocProvider<TaxBloc>(
            create: (context) => TaxBloc(context.read<TaxRepository>()),
          ),
          BlocProvider<DocumentBloc>(
            create: (context) =>
                DocumentBloc(context.read<DocumentRepository>()),
          ),
          BlocProvider<TankerReportBloc>(
            create: (context) =>
                TankerReportBloc(context.read<TankerReportRepository>()),
          ),
          BlocProvider<ExpenseBloc>(
            create: (context) => ExpenseBloc(context.read<ExpenseRepository>()),
          ),
          BlocProvider<AuditLogBloc>(
            create: (context) =>
                AuditLogBloc(context.read<AuditLogRepository>()),
          ),
        ],
        child: MaterialApp(
          title: 'Vahan Setu',
          debugShowCheckedModeBanner: false,

          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.background,
            primaryColor: AppColors.primary,

            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              secondary: AppColors.accent,
              surface: AppColors.surface,
              error: AppColors.error,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.primaryDark,
              foregroundColor: AppColors.textLight,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),

            cardTheme: CardThemeData(
              color: AppColors.surface,
              elevation: 2,
              shadowColor: AppColors.primaryDark.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: AppColors.textLight,
                elevation: 0,
                minimumSize: const Size.fromHeight(54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),

          home: const SplashScreen(),
        ),
      ),
    );
  }
}
