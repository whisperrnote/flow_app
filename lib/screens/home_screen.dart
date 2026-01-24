import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../widgets/responsive_layout.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/app_bar.dart';
import '../widgets/sidebar.dart';
import 'workflow_dashboard_screen.dart';
import 'task_list_screen.dart';
import 'calendar_screen.dart';
import 'focus_screen.dart';
import 'settings_screen.dart';
import 'create_task_screen.dart';
import '../core/theme/glass_route.dart';
import '../core/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _screens = [
    const WorkflowDashboardScreen(),
    const TaskListScreen(),
    const FocusScreen(),
    const CalendarScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userInitials = authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U';

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.voidBg,
      drawer: ResponsiveLayout.isDesktop(context) 
        ? null 
        : Drawer(
            width: 280,
            backgroundColor: AppColors.voidBg,
            child: FlowSidebar(
              selectedIndex: _selectedIndex,
              onTap: (index) {
                setState(() => _selectedIndex = index);
                Navigator.pop(context);
              },
            ),
          ),
      body: ResponsiveLayout(
        mobile: Stack(
          children: [
            Column(
              children: [
                FlowAppBar(
                  onMenuTap: () => _scaffoldKey.currentState?.openDrawer(),
                  userInitials: userInitials,
                ),
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _screens,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: FlowBottomNav(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                onAddTap: () => Navigator.push(
                  context,
                  GlassRoute(page: const CreateTaskScreen()),
                ),
              ),
            ),
          ],
        ),
        desktop: Row(
          children: [
            FlowSidebar(
              selectedIndex: _selectedIndex,
              onTap: (index) => setState(() => _selectedIndex = index),
            ),
            const VerticalDivider(width: 1, color: AppColors.borderSubtle),
            Expanded(
              child: Column(
                children: [
                  FlowAppBar(
                    onMenuTap: () {},
                    userInitials: userInitials,
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _selectedIndex,
                      children: _screens.map((s) {
                        if (s is WorkflowDashboardScreen) {
                          return const WorkflowDashboardScreen(isDesktop: true);
                        }
                        return s;
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
