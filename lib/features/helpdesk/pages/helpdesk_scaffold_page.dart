import 'package:flutter/material.dart';
import '../widgets/helpdesk_bottom_nav_bar.dart';
import '../dashboard/presentation/pages/helpdesk_dashboard_page.dart';
import '../tasks/presentation/pages/helpdesk_task_list_page.dart';
import '../notifications/presentation/pages/helpdesk_notifications_page.dart';
import '../profile/presentation/pages/helpdesk_profile_page.dart';

/// Scaffold utama untuk role Helpdesk dengan bottom navigation.
/// Berbeda dari AdminScaffoldPage: Tab ke-2 adalah "Tugas" (bukan "Tiket").
class HelpdeskScaffoldPage extends StatefulWidget {
  const HelpdeskScaffoldPage({super.key});

  @override
  State<HelpdeskScaffoldPage> createState() => _HelpdeskScaffoldPageState();
}

class _HelpdeskScaffoldPageState extends State<HelpdeskScaffoldPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HelpdeskDashboardPage(),
    const HelpdeskTaskListPage(),
    const HelpdeskNotificationsPage(),
    const HelpdeskProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: HelpdeskBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        notificationCount: 3,
        taskCount: 2, // Jumlah tiket baru yang perlu dikerjakan
      ),
    );
  }
}
