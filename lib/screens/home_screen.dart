import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Flows',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: AppColors.titanium,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 8, height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.electric,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '3 ACTIVE',
                            style: GoogleFonts.spaceMono(
                              color: AppColors.electric,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => context.read<AuthProvider>().logout(),
                    icon: const Icon(LucideIcons.logOut, color: AppColors.gunmetal),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            // Flow List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: 4,
                separatorBuilder: (_, __) => const SizedBox(height: 20),
                itemBuilder: (context, index) => _buildFlowCard(index),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: AppColors.electric,
        child: const Icon(LucideIcons.plus, color: AppColors.voidBg),
      ),
    );
  }

  Widget _buildFlowCard(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.electricDim,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(LucideIcons.zap, color: AppColors.electric, size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Daily Digest',
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.titanium,
                            ),
                          ),
                          Switch(
                            value: true, 
                            onChanged: (_) {},
                            activeColor: AppColors.electric,
                            activeTrackColor: AppColors.electricDim,
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Summarize emails and calendar events every morning at 8:00 AM.',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.gunmetal,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Connection Line Visualization
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.borderSubtle)),
            ),
            child: Row(
              children: [
                _buildNodeIcon(LucideIcons.mail),
                _buildConnector(),
                _buildNodeIcon(LucideIcons.calendar),
                _buildConnector(),
                _buildNodeIcon(LucideIcons.bot),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNodeIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Icon(icon, size: 14, color: AppColors.gunmetal),
    );
  }

  Widget _buildConnector() {
    return Expanded(
      child: Container(
        height: 1,
        color: AppColors.borderSubtle,
        margin: const EdgeInsets.symmetric(horizontal: 4),
      ),
    );
  }
}
