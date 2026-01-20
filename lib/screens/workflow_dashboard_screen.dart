import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/theme/colors.dart';
import 'package:intl/intl.dart';
import 'task_detail_sheet.dart';

import '../widgets/glass_card.dart';

import 'settings_screen.dart';
import 'create_task_screen.dart';
import '../core/theme/glass_route.dart';

class WorkflowDashboardScreen extends StatelessWidget {
  final bool isDesktop;
  const WorkflowDashboardScreen({super.key, this.isDesktop = false});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(now).toUpperCase();

    return Scaffold(
      backgroundColor: AppColors.voidBg,
      body: Stack(
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

          SafeArea(
            child: Column(
              children: [
                // New Header with Profile
                GlassCard(
                  borderRadius: BorderRadius.zero,
                  opacity: 0.8,
                  border: const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'ORCHESTRATOR',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                              color: AppColors.electric,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Workflows',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titanium,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          if (isDesktop) ...[
                            _DesktopHeaderAction(LucideIcons.plus, () {
                              Navigator.push(context, GlassRoute(page: const CreateTaskScreen()));
                            }, isPrimary: true),
                            const SizedBox(width: 8),
                          ],
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                GlassRoute(page: const SettingsScreen()),
                              );
                            },
                            child: Container(
                              width: 40, height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.electric,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.voidBg, width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  'U',
                                  style: GoogleFonts.spaceGrotesk(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.voidBg,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        Text(
                          'Welcome back.',
                          style: GoogleFonts.spaceGrotesk(
                            fontSize: isDesktop ? 48 : 32,
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
                                  const TextSpan(text: 'Today is '),
                                  TextSpan(
                                    text: '80% executed',
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
                        if (isDesktop)
                          Row(
                            children: [
                              Expanded(child: _buildStatCard(title: 'ACTIVE FLOWS', value: '12', subtitle: '4 running now', icon: LucideIcons.activity, color: AppColors.electric, delay: 0)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard(title: 'TASKS PENDING', value: '08', subtitle: '3 high priority', icon: LucideIcons.checkCircle, color: const Color(0xFF10B981), delay: 100)),
                              const SizedBox(width: 16),
                              Expanded(child: _buildStatCard(title: 'TIME SAVED', value: '4.2h', subtitle: 'This week', icon: LucideIcons.zap, color: Colors.orangeAccent, delay: 200)),
                            ],
                          )
                        else
                          SizedBox(
                            height: 140,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              clipBehavior: Clip.none,
                              children: [
                                _buildStatCard(title: 'ACTIVE FLOWS', value: '12', subtitle: '4 running now', icon: LucideIcons.activity, color: AppColors.electric, delay: 0),
                                const SizedBox(width: 16),
                                _buildStatCard(title: 'TASKS PENDING', value: '08', subtitle: '3 high priority', icon: LucideIcons.checkCircle, color: const Color(0xFF10B981), delay: 100),
                                const SizedBox(width: 16),
                                _buildStatCard(title: 'TIME SAVED', value: '4.2h', subtitle: 'This week', icon: LucideIcons.zap, color: Colors.orangeAccent, delay: 200),
                              ],
                            ),
                          ),

                        const SizedBox(height: 48),

                        if (isDesktop)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    _buildSectionHeader('CRITICAL TRACK', LucideIcons.target, const Color(0xFFFF4D4D)),
                                    const SizedBox(height: 16),
                                    _buildTaskItem(title: 'Sync Note Attachments', tag: 'SYSTEM', tagColor: AppColors.electric, time: 'Active'),
                                    _buildTaskItem(title: 'Keep Vault Audit', tag: 'SECURITY', tagColor: const Color(0xFFFF4D4D), time: 'Scheduled'),
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
                          _buildSectionHeader('CRITICAL TRACK', LucideIcons.target, const Color(0xFFFF4D4D)),
                          const SizedBox(height: 16),
                          _buildTaskItem(title: 'Sync Note Attachments', tag: 'SYSTEM', tagColor: AppColors.electric, time: 'Active'),
                          _buildTaskItem(title: 'Keep Vault Audit', tag: 'SECURITY', tagColor: const Color(0xFFFF4D4D), time: 'Scheduled'),
                          const SizedBox(height: 32),
                          _buildSystemPerformance(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: isDesktop ? null : _buildMobileFAB(context),
    );
  }

  Widget _buildSystemPerformance() {
    return GlassCard(
      opacity: 0.4,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SYSTEM PERFORMANCE',
            style: GoogleFonts.spaceGrotesk(fontSize: 10, fontWeight: FontWeight.w900, color: AppColors.gunmetal, letterSpacing: 2),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('AUTOMATION QUOTA', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.titanium)),
              Text('94%', style: GoogleFonts.spaceMono(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.electric)),
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
    ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildMobileFAB(BuildContext context) {
    return Container(
      height: 64, width: 64,
      decoration: BoxDecoration(
        color: AppColors.electric,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: AppColors.electric.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, GlassRoute(page: const CreateTaskScreen()));
        },
        backgroundColor: Colors.transparent,
        elevation: 0,
        highlightElevation: 0,
        child: const Icon(LucideIcons.zap, color: AppColors.voidBg, size: 28),
      ),
    );
  }
}

class _DesktopHeaderAction extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const _DesktopHeaderAction(this.icon, this.onTap, {this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: isPrimary ? AppColors.electric : AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isPrimary ? AppColors.electric : AppColors.borderSubtle),
        ),
        child: Icon(icon, size: 16, color: isPrimary ? AppColors.voidBg : AppColors.electric),
      ),
    );
  }
}


  Widget _buildStatCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
    required int delay,
  }) {
    return GlassCard(
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
              children: [
                Icon(icon, size: 16, color: color),
              ],
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
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.gunmetal.withOpacity(0.5)),
                ),
                child: const Icon(LucideIcons.check, size: 14, color: Colors.transparent),
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
                          width: 3, height: 3,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(color: AppColors.gunmetal, shape: BoxShape.circle),
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
              Icon(LucideIcons.chevronRight, size: 16, color: AppColors.gunmetal.withOpacity(0.3)),
            ],
          ),
        ),
      ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.05, end: 0),
    );
  }
}
