import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/workflow_service.dart';
import '../core/models/task_model.dart';
import '../core/models/focus_session_model.dart';
import '../widgets/glass_card.dart';
import 'dart:async';

class FocusScreen extends StatefulWidget {
  final Task? initialTask;
  const FocusScreen({super.key, this.initialTask});

  @override
  State<FocusScreen> createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  final WorkflowService _workflowService = WorkflowService();
  FocusSession? _currentSession;
  Timer? _timer;
  int _secondsRemaining = 25 * 60;
  bool _isActive = false;

  void _startTimer() {
    _isActive = true;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _isActive = false;
    _timer?.cancel();
  }

  String _formatTime(int seconds) {
    final m = (seconds / 60).floor();
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        Text(
          'SYNTHESIS',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 10,
            fontWeight: FontWeight.w900,
            color: AppColors.electric,
            letterSpacing: 4,
          ),
        ),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.initialTask != null)
                  Text(
                    'Focusing on: ${widget.initialTask!.title}',
                    style: GoogleFonts.inter(
                      color: AppColors.gunmetal,
                      fontSize: 14,
                    ),
                  ).animate().fadeIn(),
                const SizedBox(height: 48),
                Text(
                  _formatTime(_secondsRemaining),
                  style: GoogleFonts.spaceMono(
                    fontSize: 84,
                    fontWeight: FontWeight.w900,
                    color: AppColors.titanium,
                    letterSpacing: -4,
                  ),
                ).animate().scale(duration: 400.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 64),
                GestureDetector(
                  onTap: _isActive ? _stopTimer : _startTimer,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: _isActive ? Colors.transparent : AppColors.electric,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.electric, width: 2),
                    ),
                    child: Icon(
                      _isActive ? LucideIcons.pause : LucideIcons.play,
                      color: _isActive ? AppColors.electric : AppColors.voidBg,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
