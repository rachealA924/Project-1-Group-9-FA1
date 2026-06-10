import 'package:flutter/material.dart';
import 'package:alu_connect/theme/app_theme.dart';
import 'package:alu_connect/features/events/widgets/shared_widgets.dart';
import 'package:alu_connect/features/events/screens/create_event2.dart';

class CreateEventStep1Screen extends StatefulWidget {
  const CreateEventStep1Screen({super.key});

  @override
  State<CreateEventStep1Screen> createState() => _CreateEventStep1ScreenState();
}

class _CreateEventStep1ScreenState extends State<CreateEventStep1Screen> {
  int _selectedCategory = 0;
  bool _isVirtual = false;
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _categories = ['Workshop', 'Social', 'Academic', 'Sports', 'Career'];
  final List<IconData> _categoryIcons = [
    Icons.construction_rounded,
    Icons.people_rounded,
    Icons.school_rounded,
    Icons.sports_soccer_rounded,
    Icons.work_rounded,
  ];

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
            onSurface: AppColors.textPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AluAppBar(
        showBack: true,
        title: 'Create Event',
        actions: [
          IconButton(
            icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const StepIndicator(
                    currentStep: 1,
                    totalSteps: 2,
                    stepLabel: '50% Complete',
                    progress: 0.5,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Basic Details',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 20),

                  //
                  const _FieldLabel(label: 'Event Title'),
                  const SizedBox(height: 8),
                  const TextField(
                    decoration: InputDecoration(hintText: 'e.g., Annual Tech Symposium 2024'),
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),

                  //
                  const _FieldLabel(label: 'Event Category'),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(_categories.length, (i) {
                      final active = i == _selectedCategory;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primary.withOpacity(0.15) : AppColors.surface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: active ? AppColors.primary : AppColors.border,
                              width: active ? 1.5 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(_categoryIcons[i], size: 14, color: active ? AppColors.primary : AppColors.textMuted),
                              const SizedBox(width: 6),
                              Text(
                                _categories[i],
                                style: TextStyle(
                                  color: active ? AppColors.primary : AppColors.textSecondary,
                                  fontSize: 13,
                                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),

                  //
                  const _FieldLabel(label: 'Event Date'),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceVariant,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedDate == null
                                  ? 'mm/dd/yyyy'
                                  : '${_selectedDate!.month}/${_selectedDate!.day}/${_selectedDate!.year}',
                              style: TextStyle(
                                color: _selectedDate == null ? AppColors.textMuted : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Icon(Icons.calendar_month_rounded, color: AppColors.textMuted, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //
                  const _FieldLabel(label: 'Time Range'),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickTime(true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              _startTime == null ? '--:-- --' : _startTime!.format(context),
                              style: TextStyle(
                                color: _startTime == null ? AppColors.textMuted : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text('to', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _pickTime(false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceVariant,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              _endTime == null ? '--:-- --' : _endTime!.format(context),
                              style: TextStyle(
                                color: _endTime == null ? AppColors.textMuted : AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  //
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const _FieldLabel(label: 'Venue'),
                      Row(
                        children: [
                          const Text('Virtual Event', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                          const SizedBox(width: 8),
                          Switch(
                            value: _isVirtual,
                            onChanged: (v) => setState(() => _isVirtual = v),
                            activeColor: AppColors.primary,
                            inactiveThumbColor: AppColors.textMuted,
                            inactiveTrackColor: AppColors.border,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Search for a campus building or room...',
                            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Recommended: Innovation Hub - Ground Floor',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 20),

                  //
                  const _FieldLabel(label: 'Description'),
                  const SizedBox(height: 8),
                  const TextField(
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Tell students what to expect, what to bring, and why they should join...',
                      alignLabelWithHint: true,
                    ),
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            decoration: const BoxDecoration(
              color: AppColors.background,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: AccentButton(label: 'Save Draft', outlined: true, onPressed: () {}),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: AccentButton(
                    label: 'Next: Event Media',
                    trailingIcon: Icons.arrow_forward_rounded,
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CreateEventStep2Screen()),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}