import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../widgets/whisperr_shimmer.dart';
import '../core/theme/colors.dart';
import 'package:intl/intl.dart';
import 'task_detail_sheet.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/workflow_service.dart';
import '../core/models/task_model.dart';
import '../widgets/glass_card.dart';
import 'settings_screen.dart';
import 'create_task_screen.dart';
import 'calendar_screen.dart';
import 'focus_screen.dart';
import '../core/theme/glass_route.dart';

class WorkflowDashboardScreen extends StatefulWidget {
  final bool isDesktop;
  const WorkflowDashboardScreen({super.key, this.isDesktop = false});

  @override
  State<WorkflowDashboardScreen> createState() =>
      _WorkflowDashboardScreenState();
}

class _WorkflowDashboardScreenState extends State<WorkflowDashboardScreen> {
  final WorkflowService _workflowService = WorkflowService();
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      try {
        final tasks = await _workflowService.listTasks(authProvider.user!.$id);
        if (mounted) {
          setState(() {
            _tasks = tasks;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(now).toUpperCase();
    final authProvider = Provider.of<AuthProvider>(context);

    return Stack(
      children: [
        // Background Gradient
        Positioned(
          top: -100,
          right: -100,
          child: Container(
            width: 350,
            height: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.electric.withOpacity(0.08),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        RefreshIndicator(
          onRefresh: _fetchTasks,
          color: AppColors.electric,
          backgroundColor: AppColors.surface,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                // Welcome Section
                Text(
                      'Welcome back, ${authProvider.user?.name.split(' ')[0] ?? ''}.',
                      style: GoogleFonts.spaceGrotesk(
                        fontSize: widget.isDesktop ? 48 : 32,
                        fontWeight: FontWeight.w900,
                        color: AppColors.titanium,
                        letterSpacing: -1,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: 600.ms)
                    .slideY(begin: -0.2, end: 0),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Text(
                      dateStr,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.gunmetal,
                        letterSpacing: 1,
                      ),
                    ),
                    Container(
                      height: 16,
                      width: 1,
                      color: AppColors.borderSubtle,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppColors.gunmetal,
                        ),
                        children: [
                          const TextSpan(text: 'Today is '),
                          TextSpan(
                            text: _tasks.isEmpty
                                ? '0% executed'
                                : '${((_tasks.where((t) => t.status == 'completed').length / _tasks.length) * 100).toInt()}% executed',
                            style: TextStyle(
                              color: AppColors.electric,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 32),

                // Stats Row/Grid
                if (widget.isDesktop)
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'ACTIVE FLOWS',
                          value: _tasks
                              .where((t) => t.status != 'completed')
                              .length
                              .toString(),
                          subtitle: '4 running now',
                          icon: LucideIcons.activity,
                          color: AppColors.electric,
                          delay: 0,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'TASKS PENDING',
                          value: _tasks
                              .where((t) => t.status == 'pending')
                              .length
                              .toString(),
                          subtitle: '3 high priority',
                          icon: LucideIcons.checkCircle,
                          color: const Color(0xFF10B981),
                          delay: 100,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'COMPLETED',
                          value: _tasks
                              .where((t) => t.status == 'completed')
                              .length
                              .toString(),
                          subtitle: 'This week',
                          icon: LucideIcons.zap,
                          color: Colors.orangeAccent,
                          delay: 200,
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(
                    height: 140,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      clipBehavior: Clip.none,
                      children: [
                        _buildStatCard(
                          title: 'ACTIVE FLOWS',
                          value: _tasks
                              .where((t) => t.status != 'completed')
                              .length
                              .toString(),
                          subtitle: '4 running now',
                          icon: LucideIcons.activity,
                          color: AppColors.electric,
                          delay: 0,
                          onTap: () => Navigator.push(
                            context,
                            GlassRoute(page: const FocusScreen()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          title: 'CALENDAR',
                          value: 'VIEW',
                          subtitle: 'Schedule',
                          icon: LucideIcons.calendar,
                          color: const Color(0xFF10B981),
                          delay: 100,
                          onTap: () => Navigator.push(
                            context,
                            GlassRoute(page: const CalendarScreen()),
                          ),
                        ),
                        const SizedBox(width: 16),
                        _buildStatCard(
                          title: 'COMPLETED',
                          value: _tasks
                              .where((t) => t.status == 'completed')
                              .length
                              .toString(),
                          subtitle: 'This week',
                          icon: LucideIcons.zap,
                          color: Colors.orangeAccent,
                          delay: 200,
                        ),
                      ],
                    ),
                  ),

                const SizedBox(height: 48),

                if (_isLoading)
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.electric,
                    ),
                  )
                else if (_tasks.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          LucideIcons.clipboardList,
                          size: 48,
                          color: AppColors.gunmetal,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks found.',
                          style: GoogleFonts.inter(
                            color: AppColors.gunmetal,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.isDesktop)
                        Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                children: [
                                  _buildSectionHeader(
                                    'CRITICAL TRACK',
                                    LucideIcons.target,
                                    const Color(0xFFFF4D4D),
                                  ),
                                  const SizedBox(height: 16),
                                  ..._tasks.map(
                                    (task) => _buildTaskItem(
                                      task: task,
                                      tag: task.priority
                                          .toUpperCase(),
                                      tagColor:
                                          task.priority == 'high'
                                          ? const Color(0xFFFF4D4D)
                                          : AppColors.electric,
                                      time: task.status.toUpperCase(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: _buildSystemPerformance(),
                            ),
                          ],
                        )
                      else ...[
                        _buildSectionHeader(
                          'CRITICAL TRACK',
                          LucideIcons.target,
                          const Color(0xFFFF4D4D),
                        ),
                        const SizedBox(height: 16),
                        ..._tasks.map(
                          (task) => _buildTaskItem(
                            task: task,
                            tag: task.priority.toUpperCase(),
                            tagColor: task.priority == 'high'
                                ? const Color(0xFFFF4D4D)
                                : AppColors.electric,
                            time: task.status.toUpperCase(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildSystemPerformance(),
                      ],
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSystemPerformance() {
    final completedCount = _tasks.where((t) => t.status == 'completed').length;
    final totalCount = _tasks.length;
    final quota = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return GlassCard(
          opacity: 0.4,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SYSTEM PERFORMANCE',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gunmetal,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AUTOMATION QUOTA',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.titanium,
                    ),
                  ),
                  Text(
                    '${(quota * 100).toInt()}%',
                    style: GoogleFonts.spaceMono(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.electric,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: quota,
                  minHeight: 6,
                  backgroundColor: AppColors.surface2,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.electric,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 400.ms)
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child:
          GlassCard(
                opacity: 0.3,
                padding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 140,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [Icon(icon, size: 16, color: color)],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.titanium,
                              height: 1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            title,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              color: AppColors.gunmetal,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: delay.ms)
              .slideX(begin: 0.1, end: 0),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: AppColors.titanium,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        Text(
          'VIEW ALL',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: AppColors.gunmetal,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskItem({
    required Task task,
    required String tag,
    required Color tagColor,
    required String time,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TaskDetailSheet(
              title: task.title,
              tag: tag,
              tagColor: tagColor,
            ),
          );
          _fetchTasks();
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: GlassCard(
            opacity: 0.3,
            padding: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    final newStatus = task.status == 'completed'
                        ? 'pending'
                        : 'completed';
                    await _workflowService.updateTaskStatus(task.id, newStatus);
                    _fetchTasks();
                  },
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: task.status == 'completed'
                          ? AppColors.electric
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: task.status == 'completed'
                            ? AppColors.electric
                            : AppColors.gunmetal.withOpacity(0.5),
                      ),
                    ),
                    child: Icon(
                      LucideIcons.check,
                      size: 14,
                      color: task.status == 'completed'
                          ? AppColors.voidBg
                          : Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          color: AppColors.titanium,
                          fontSize: 14,
                          decoration: task.status == 'completed'
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            tag,
                            style: GoogleFonts.spaceMono(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: tagColor,
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 3,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: const BoxDecoration(
                              color: AppColors.gunmetal,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Text(
                            time,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.gunmetal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: AppColors.gunmetal.withOpacity(0.3),
                ),
              ],
            ),
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0),
    );
  }
}