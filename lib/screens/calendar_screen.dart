import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../core/providers/auth_provider.dart';
import '../core/services/workflow_service.dart';
import '../core/models/calendar_model.dart';
import '../core/models/event_model.dart';
import '../widgets/glass_card.dart';
import 'create_event_screen.dart';
import '../core/theme/glass_route.dart';
import 'package:intl/intl.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final WorkflowService _workflowService = WorkflowService();
  List<Calendar> _calendars = [];
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      try {
        final calendars = await _workflowService.listCalendars(
          authProvider.user!.$id,
        );
        final events = await _workflowService.listEvents(
          authProvider.user!.$id,
        );
        setState(() {
          _calendars = calendars;
          _events = events;
          _isLoading = false;
        });
      } catch (e) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.electric),
          )
        : SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TIME DIMENSION',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: AppColors.electric,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your Schedule',
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titanium,
                  ),
                ).animate().fadeIn().slideY(begin: 0.1, end: 0),
                const SizedBox(height: 32),
                if (_events.isEmpty)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        Icon(LucideIcons.calendar, size: 80, color: AppColors.gunmetal.withOpacity(0.2)),
                        const SizedBox(height: 24),
                        Text(
                          'No events scheduled.',
                          style: GoogleFonts.inter(color: AppColors.gunmetal),
                        ),
                      ],
                    ),
                  )
                else
                  ..._events.map((event) => _buildEventCard(event)),
              ],
            ),
          );
  }

  Widget _buildEventCard(Event event) {
    final timeFormat = DateFormat('jm');
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassCard(
        opacity: 0.3,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${timeFormat.format(event.startTime)} - ${timeFormat.format(event.endTime)}',
                  style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.electric,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.electric.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    event.visibility.toUpperCase(),
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                      color: AppColors.electric,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              event.title,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.titanium,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              event.description,
              style: GoogleFonts.inter(fontSize: 13, color: AppColors.gunmetal),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate().fadeIn().slideX(begin: 0.05, end: 0);
  }
}
