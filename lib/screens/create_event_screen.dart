import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../widgets/glass_card.dart';
import '../core/services/workflow_service.dart';
import '../core/providers/auth_provider.dart';
import '../core/models/calendar_model.dart';
import 'package:intl/intl.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final WorkflowService _workflowService = WorkflowService();

  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  DateTime _endDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay _endTime = TimeOfDay.fromDateTime(
    DateTime.now().add(const Duration(hours: 1)),
  );

  String _visibility = 'public';
  bool _isSaving = false;
  List<Calendar> _calendars = [];
  String? _selectedCalendarId;

  @override
  void initState() {
    super.initState();
    _fetchCalendars();
  }

  Future<void> _fetchCalendars() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.user != null) {
      try {
        final calendars = await _workflowService.listCalendars(
          authProvider.user!.$id,
        );
        setState(() {
          _calendars = calendars;
          if (calendars.isNotEmpty) {
            _selectedCalendarId = calendars.first.id;
          }
        });
      } catch (e) {
        // Handle error
      }
    }
  }

  Future<void> _handleSave() async {
    if (_titleController.text.isEmpty || _selectedCalendarId == null) return;

    setState(() => _isSaving = true);
    // Implementation for creating event would go here
    // For now just pop
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) Navigator.pop(context);
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'NEW EVENT',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 14,
            fontWeight: FontWeight.w900,
            color: AppColors.electric,
            letterSpacing: 2,
          ),
        ),
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: AppColors.titanium),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('TITLE'),
            TextField(
              controller: _titleController,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.titanium,
              ),
              decoration: InputDecoration(
                hintText: 'Event Title',
                hintStyle: GoogleFonts.spaceGrotesk(
                  color: AppColors.gunmetal.withOpacity(0.3),
                ),
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 32),
            _buildLabel('CALENDAR'),
            const SizedBox(height: 12),
            if (_calendars.isEmpty)
              Text(
                'No calendars found',
                style: GoogleFonts.inter(color: AppColors.gunmetal),
              )
            else
              DropdownButtonFormField<String>(
                value: _selectedCalendarId,
                dropdownColor: AppColors.surface,
                style: GoogleFonts.inter(color: AppColors.titanium),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.surface2.withOpacity(0.5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                items: _calendars
                    .map(
                      (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _selectedCalendarId = val),
              ),
            const SizedBox(height: 32),
            _buildLabel('START TIME'),
            const SizedBox(height: 12),
            _buildDateTimePicker(
              date: _startDate,
              time: _startTime,
              onDateTap: () async {
                final d = await showDatePicker(
                  context: context,
                  initialDate: _startDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (d != null) setState(() => _startDate = d);
              },
              onTimeTap: () async {
                final t = await showTimePicker(
                  context: context,
                  initialTime: _startTime,
                );
                if (t != null) setState(() => _startTime = t);
              },
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.electric,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: AppColors.voidBg)
                    : Text(
                        'CREATE EVENT',
                        style: GoogleFonts.spaceGrotesk(
                          fontWeight: FontWeight.w900,
                          color: AppColors.voidBg,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.spaceGrotesk(
        fontSize: 10,
        fontWeight: FontWeight.w900,
        color: AppColors.gunmetal,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildDateTimePicker({
    required DateTime date,
    required TimeOfDay time,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
  }) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onDateTap,
            child: GlassCard(
              opacity: 0.3,
              padding: const EdgeInsets.all(16),
              child: Text(
                DateFormat('yMMMd').format(date),
                style: GoogleFonts.inter(color: AppColors.titanium),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onTimeTap,
            child: GlassCard(
              opacity: 0.3,
              padding: const EdgeInsets.all(16),
              child: Text(
                time.format(context),
                style: GoogleFonts.inter(color: AppColors.titanium),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
