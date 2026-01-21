import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../core/theme/colors.dart';
import '../widgets/glass_card.dart';
import '../core/services/workflow_service.dart';
import '../core/providers/auth_provider.dart';

class CreateTaskScreen extends StatefulWidget {
  const CreateTaskScreen({super.key});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final WorkflowService _workflowService = WorkflowService();
  String _priority = 'NORMAL'; // 'LOW', 'NORMAL', 'HIGH', 'CRITICAL'
  DateTime _dueDate = DateTime.now();
  bool _isSaving = false;

  Future<void> _handleSave() async {
    if (_titleController.text.isEmpty) return;

    setState(() => _isSaving = true);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      if (authProvider.user != null) {
        await _workflowService.createTask(
          userId: authProvider.user!.$id,
          title: _titleController.text,
          description: _descController.text,
          status: 'pending',
          priority: _priority.toLowerCase(),
          dueDate: _dueDate,
        );
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to initiate flow: $e')));
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.voidBg,
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                // Header
                GlassCard(
                  borderRadius: BorderRadius.zero,
                  opacity: 0.8,
                  border: const Border(
                    bottom: BorderSide(color: AppColors.borderSubtle),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          LucideIcons.arrowLeft,
                          color: AppColors.gunmetal,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'NEW OBJECTIVE',
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.w900,
                          color: AppColors.electric,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(24),
                    children: [
                      _buildLabel('DESIGNATION'),
                      TextField(
                        controller: _titleController,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.titanium,
                        ),
                        decoration: InputDecoration(
                          hintText: 'What is the goal?',
                          hintStyle: GoogleFonts.spaceGrotesk(
                            color: AppColors.gunmetal.withOpacity(0.3),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildLabel('PRIORITY LEVEL'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _buildPriorityChip('LOW', Colors.blue),
                          const SizedBox(width: 8),
                          _buildPriorityChip('NORMAL', AppColors.electric),
                          const SizedBox(width: 8),
                          _buildPriorityChip('HIGH', Colors.orange),
                          const SizedBox(width: 8),
                          _buildPriorityChip('CRITICAL', Colors.red),
                        ],
                      ),

                      const SizedBox(height: 32),

                      _buildLabel('CHRONOLOGY'),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          if (date != null) setState(() => _dueDate = date);
                        },
                        child: GlassCard(
                          opacity: 0.3,
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              const Icon(
                                LucideIcons.calendar,
                                size: 18,
                                color: AppColors.electric,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                'Due ${_dueDate.day}/${_dueDate.month}/${_dueDate.year}',
                                style: GoogleFonts.inter(
                                  color: AppColors.titanium,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                LucideIcons.chevronDown,
                                size: 16,
                                color: AppColors.gunmetal,
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      _buildLabel('SPECIFICATIONS'),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descController,
                        maxLines: 5,
                        style: GoogleFonts.inter(
                          color: AppColors.titanium,
                          height: 1.5,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Describe the outcome...',
                          hintStyle: GoogleFonts.inter(
                            color: AppColors.gunmetal.withOpacity(0.5),
                          ),
                          filled: true,
                          fillColor: AppColors.surface2.withOpacity(0.5),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.borderSubtle,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                              color: AppColors.borderSubtle,
                            ),
                          ),
                        ),
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
                              ? const CircularProgressIndicator(
                                  color: AppColors.voidBg,
                                )
                              : Text(
                                  'INITIATE FLOW',
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
                ),
              ],
            ),
          ),
        ],
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

  Widget _buildPriorityChip(String label, Color color) {
    final isSelected = _priority == label;
    return GestureDetector(
      onTap: () => setState(() => _priority = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.2) : AppColors.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.spaceMono(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isSelected ? color : AppColors.gunmetal,
          ),
        ),
      ),
    );
  }
}
