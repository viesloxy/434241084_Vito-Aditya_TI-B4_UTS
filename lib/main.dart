import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/splash/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/home/pages/main_scaffold_page.dart';
import 'features/tickets/pages/create_ticket_page.dart';
import 'features/tickets/pages/ticket_detail_page.dart';
import 'features/tickets/pages/ticket_history_page.dart';
import 'features/notifications/presentation/pages/notifications_page.dart';

// Admin imports
import 'features/admin/pages/admin_scaffold_page.dart';
import 'features/admin/dashboard/presentation/pages/admin_dashboard_page.dart';
import 'features/admin/tickets/presentation/pages/admin_ticket_list_page.dart';
import 'features/admin/tickets/presentation/pages/admin_ticket_detail_page.dart';
import 'features/admin/notifications/presentation/pages/admin_notifications_page.dart';
import 'features/admin/profile/presentation/pages/admin_profile_page.dart';

// Helpdesk imports
import 'features/helpdesk/pages/helpdesk_scaffold_page.dart';
import 'features/helpdesk/dashboard/presentation/pages/helpdesk_dashboard_page.dart';
import 'features/helpdesk/tasks/presentation/pages/helpdesk_task_list_page.dart';
import 'features/helpdesk/tasks/presentation/pages/helpdesk_task_detail_page.dart';
import 'features/helpdesk/notifications/presentation/pages/helpdesk_notifications_page.dart';
import 'features/helpdesk/profile/presentation/pages/helpdesk_profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Helpdesk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        // Splash & Auth
        '/': (context) => const SplashPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),

        // User Routes
        '/home': (context) => const MainScaffoldPage(),
        '/create-ticket': (context) => const CreateTicketPage(),
        '/ticket-detail': (context) => const TicketDetailPage(),
        '/tickets': (context) => const TicketHistoryPage(),
        '/notifications': (context) => const NotificationsPage(),

        // Admin Routes (Pengelola Sistem)
        '/admin': (context) => const AdminScaffoldPage(),
        '/admin/dashboard': (context) => const AdminDashboardPage(),
        '/admin/tickets': (context) => const AdminTicketListPage(),
        '/admin/ticket-detail': (context) => const AdminTicketDetailPage(),
        '/admin/notifications': (context) => const AdminNotificationsPage(),
        '/admin/profile': (context) => const AdminProfilePage(),

        // Helpdesk Routes (Petugas Support)
        '/helpdesk': (context) => const HelpdeskScaffoldPage(),
        '/helpdesk/dashboard': (context) => const HelpdeskDashboardPage(),
        '/helpdesk/tasks': (context) => const HelpdeskTaskListPage(),
        '/helpdesk/task-detail': (context) => const HelpdeskTaskDetailPage(),
        '/helpdesk/notifications': (context) =>
            const HelpdeskNotificationsPage(),
        '/helpdesk/profile': (context) => const HelpdeskProfilePage(),
      },
    );
  }
}
