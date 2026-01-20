import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../core/theme/colors.dart';

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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: tagColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: tagColor.withOpacity(0.3)),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.spaceMono(
                    color: tagColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(LucideIcons.x, color: AppColors.gunmetal),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.titanium,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 24),
          
          _buildDetailRow(LucideIcons.calendar, 'Due Today, 14:00'),
          const SizedBox(height: 12),
          _buildDetailRow(LucideIcons.users, 'Assigned to Dev Team'),
          const SizedBox(height: 12),
          _buildDetailRow(LucideIcons.link, 'Attached: PR #142'),

          const SizedBox(height: 32),
          
          Text(
            'Description',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.gunmetal,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ensure the new authentication flow handles edge cases involving refresh tokens and biometrics.',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.titanium,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 32),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.electric,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                'Mark Complete',
                style: GoogleFonts.inter(
                  color: AppColors.voidBg,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.gunmetal),
        const SizedBox(width: 12),
        Text(
          text,
          style: GoogleFonts.inter(
            color: AppColors.titanium,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
