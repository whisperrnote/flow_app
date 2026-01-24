import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../widgets/glass_card.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/workflow_service.dart';
import '../core/models/task_model.dart';
import 'task_detail_sheet.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final WorkflowService _workflowService = WorkflowService();
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _viewMode = 'list'; // 'list', 'board', 'calendar'

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
    return Scaffold(
      backgroundColor: AppColors.voidBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildViewToggle(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.electric))
                  : _tasks.isEmpty
                      ? _buildEmptyState()
                      : _buildTaskList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ALL TASKS',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -1,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.electric,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.electric, blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_tasks.length} ACTION ITEMS',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.gunmetal,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            icon: const Icon(LucideIcons.filter, color: AppColors.gunmetal),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          _ToggleItem(
            icon: LucideIcons.list,
            isActive: _viewMode == 'list',
            onTap: () => setState(() => _viewMode = 'list'),
          ),
          _ToggleItem(
            icon: LucideIcons.layout,
            isActive: _viewMode == 'board',
            onTap: () => setState(() => _viewMode = 'board'),
          ),
          _ToggleItem(
            icon: LucideIcons.calendar,
            isActive: _viewMode == 'calendar',
            onTap: () => setState(() => _viewMode = 'calendar'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(LucideIcons.clipboardList, size: 64, color: AppColors.carbon),
          const SizedBox(height: 16),
          Text(
            'Clean Slate',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no pending tasks in this view.',
            style: GoogleFonts.inter(color: AppColors.gunmetal),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _tasks.length,
      itemBuilder: (context, index) {
        final task = _tasks[index];
        return _buildTaskItem(task);
      },
    );
  }

  Widget _buildTaskItem(Task task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TaskDetailSheet(
              title: task.title,
              tag: task.priority.toUpperCase(),
              tagColor: task.priority == 'high' ? Colors.redAccent : AppColors.electric,
            ),
          );
        },
        child: GlassCard(
          opacity: 0.3,
          padding: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: task.status == 'completed' ? AppColors.electric : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: task.status == 'completed' ? AppColors.electric : AppColors.gunmetal.withOpacity(0.5),
                ),
              ),
              child: Icon(
                LucideIcons.check,
                size: 14,
                color: task.status == 'completed' ? AppColors.voidBg : Colors.transparent,
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
                      decoration: task.status == 'completed' ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    task.priority.toUpperCase(),
                    style: GoogleFonts.spaceMono(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: task.priority == 'high' ? Colors.redAccent : AppColors.electric,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.chevronRight, size: 16, color: AppColors.carbon),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 50.ms).slideX(begin: 0.05, end: 0);
  }
}

class _ToggleItem extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.electric.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isActive ? AppColors.electric : AppColors.gunmetal,
          ),
        ),
      ),
    );
  }
}
