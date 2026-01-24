import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/colors.dart';
import 'logo.dart';

class FlowSidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const FlowSidebar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: AppColors.voidBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Logo(),
          ),
          const SizedBox(height: 8),
          _buildSectionLabel('MAIN NAVIGATION'),
          _SidebarItem(
            icon: LucideIcons.layoutDashboard,
            label: 'Dashboard',
            isActive: selectedIndex == 0,
            onTap: () => onTap(0),
          ),
          _SidebarItem(
            icon: LucideIcons.checkSquare,
            label: 'Tasks',
            isActive: selectedIndex == 1,
            onTap: () => onTap(1),
          ),
          _SidebarItem(
            icon: LucideIcons.flame,
            label: 'Focus Mode',
            isActive: selectedIndex == 2,
            onTap: () => onTap(2),
          ),
          _SidebarItem(
            icon: LucideIcons.calendar,
            label: 'Calendar',
            isActive: selectedIndex == 3,
            onTap: () => onTap(3),
          ),
          
          const Divider(height: 48, indent: 24, endIndent: 24, color: AppColors.borderSubtle),
          
          _buildSectionLabel('SMART LISTS'),
          _SidebarItem(icon: LucideIcons.inbox, label: 'Inbox', badge: '12'),
          _SidebarItem(icon: LucideIcons.calendar, label: 'Today', color: const Color(0xFF10B981), badge: '5'),
          _SidebarItem(icon: LucideIcons.clock, label: 'Upcoming', color: const Color(0xFF3B82F6)),
          _SidebarItem(icon: LucideIcons.checkCircle2, label: 'Completed'),

          const Spacer(),
          
          _buildStorageCard(),
          
          _SidebarItem(
            icon: LucideIcons.settings,
            label: 'Settings',
            onTap: () {},
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Text(
        label,
        style: GoogleFonts.spaceGrotesk(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: AppColors.carbon,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildStorageCard() {
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STORAGE USED',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 9,
              fontWeight: FontWeight.w800,
              color: AppColors.gunmetal,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.45,
              minHeight: 4,
              backgroundColor: AppColors.surface2,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.electric),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('4.5GB of 10GB', style: GoogleFonts.inter(fontSize: 9, color: AppColors.carbon)),
              Text('45%', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: AppColors.electric)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  final Color? color;
  final String? badge;

  const _SidebarItem({
    required this.icon,
    required this.label,
    this.isActive = false,
    this.onTap,
    this.color,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final displayColor = isActive ? AppColors.electric : (color ?? AppColors.gunmetal);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.electric.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: displayColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive ? Colors.white : AppColors.gunmetal,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.surface2,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  badge!,
                  style: GoogleFonts.spaceMono(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
