import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/colors.dart';
import 'package:intl/intl.dart';
import 'task_detail_sheet.dart';

class WorkflowDashboardScreen extends StatelessWidget {
  const WorkflowDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(now).toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.voidBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Text(
                'Welcome back.',
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.titanium,
                  letterSpacing: -1,
                ),
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
              
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
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.gunmetal),
                      children: [
                        const TextSpan(text: 'You have '),
                        TextSpan(
                          text: '8 tasks',
                          style: TextStyle(
                            color: AppColors.electric,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const TextSpan(text: ' due today'),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms, delay: 200.ms),

              const SizedBox(height: 32),

              // Stats Grid
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  children: [
                    _buildStatCard(
                      title: 'DUE TODAY',
                      value: '8',
                      subtitle: '12 pending tomorrow',
                      icon: LucideIcons.clock,
                      color: AppColors.electric,
                      delay: 0,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'OVERDUE',
                      value: '3',
                      subtitle: 'Immediate action',
                      icon: LucideIcons.alertTriangle,
                      color: const Color(0xFFFF4D4D),
                      delay: 100,
                    ),
                    const SizedBox(width: 16),
                    _buildStatCard(
                      title: 'COMPLETED',
                      value: '142',
                      subtitle: '94% efficiency',
                      icon: LucideIcons.checkCircle,
                      color: const Color(0xFF10B981),
                      delay: 200,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Critical Objectives
              _buildSectionHeader('CRITICAL OBJECTIVES', LucideIcons.flag, const Color(0xFFFF4D4D)),
              const SizedBox(height: 16),
              _buildTaskItem(
                title: 'Review Q1 Architecture',
                tag: 'URGENT',
                tagColor: const Color(0xFFFF4D4D),
                time: 'Due 2h',
              ),
              _buildTaskItem(
                title: 'Deploy Hotfix v1.2.4',
                tag: 'HIGH',
                tagColor: const Color(0xFFFFBD2E),
                time: 'Due 5h',
              ),

              const SizedBox(height: 32),

              // Active Track
              _buildSectionHeader('ACTIVE TRACK', LucideIcons.calendar, AppColors.electric),
              const SizedBox(height: 16),
              _buildTaskItem(
                title: 'Team Sync',
                tag: 'ROUTINE',
                tagColor: AppColors.electric,
                time: '14:00 PM',
              ),
              _buildTaskItem(
                title: 'Email Digest',
                tag: 'AUTO',
                tagColor: Colors.purpleAccent,
                time: 'Running...',
              ),

              const SizedBox(height: 48),

              // Metrics
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'RECOVERY METRICS',
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
                          'EXECUTION QUOTA',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.titanium,
                          ),
                        ),
                        Text(
                          '142 / 150',
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
                      child: const LinearProgressIndicator(
                        value: 0.94,
                        minHeight: 6,
                        backgroundColor: AppColors.surface2,
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.electric),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.electric,
        child: const Icon(LucideIcons.plus, color: AppColors.voidBg),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return Container(
      width: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  color: AppColors.gunmetal,
                  letterSpacing: 1,
                ),
              ),
              Icon(icon, size: 16, color: color),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: AppColors.titanium,
                  height: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.gunmetal,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms, delay: delay.ms).slideX(begin: 0.1, end: 0);
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
    required String title,
    required String tag,
    required Color tagColor,
    required String time,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (_) => TaskDetailSheet(title: title, tag: tag, tagColor: tagColor),
          );
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.gunmetal),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        color: AppColors.titanium,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: tagColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      tag,
                      style: GoogleFonts.spaceMono(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: tagColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
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
      ),
    );
  }
}
