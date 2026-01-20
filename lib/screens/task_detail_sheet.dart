import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/colors.dart';

import '../widgets/glass_card.dart';

class TaskDetailSheet extends StatelessWidget {
  final String title;
  final String tag;
  final Color tagColor;

  const TaskDetailSheet({
    super.key,
    required this.title,
    required this.tag,
    required this.tagColor,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
      opacity: 0.9,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: AppColors.borderSubtle,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: tagColor.withOpacity(0.3)),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.spaceMono(
                    color: tagColor,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, color: AppColors.gunmetal, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.titanium,
              height: 1.1,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 32),
          
          _buildDetailRow(LucideIcons.calendar, 'DEADLINE', 'Today, 14:00 PM'),
          const SizedBox(height: 20),
          _buildDetailRow(LucideIcons.users, 'ORCHESTRATORS', 'Dev Core Team'),
          const SizedBox(height: 20),
          _buildDetailRow(LucideIcons.link, 'RESOURCES', 'PR #142, Design Specs'),

          const SizedBox(height: 40),
          
          Text(
            'OBJECTIVE',
            style: GoogleFonts.spaceGrotesk(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: AppColors.gunmetal,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Ensure the new authentication flow handles edge cases involving refresh tokens and biometrics. Synchronization with WhisperrIDMS is required.',
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.titanium.withOpacity(0.8),
              height: 1.6,
            ),
          ),

          const SizedBox(height: 48),
          
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electric,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                'MARK AS EXECUTED',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.voidBg,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.surface2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Icon(icon, size: 16, color: AppColors.electric),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 9,
                fontWeight: FontWeight.w900,
                color: AppColors.gunmetal,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.inter(
                color: AppColors.titanium,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
