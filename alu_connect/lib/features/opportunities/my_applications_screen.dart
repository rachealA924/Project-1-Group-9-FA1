import 'package:flutter/material.dart';
import 'data/opportunities_data.dart';
import 'models/opportunity_model.dart';
import '../../theme/app_theme.dart';

class MyApplicationsScreen extends StatelessWidget {
  const MyApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // FIX: reads isApplied which is now set to true after submission
    final applied = mockOpportunities.where((o) => o.isApplied).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('My Applications',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context)),
      ),
      body: applied.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80, height: 80,
                    decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle),
                    child: const Icon(Icons.inbox_outlined,
                        size: 40, color: AppColors.textMuted)),
                  const SizedBox(height: 16),
                  const Text('No applications yet',
                      style: TextStyle(color: AppColors.textPrimary,
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  const Text('Start applying to opportunities!',
                      style: TextStyle(
                          color: AppColors.textMuted, fontSize: 13)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: applied.length,
              itemBuilder: (context, index) {
                final opp = applied[index];
                return _ApplicationCard(opportunity: opp);
              },
            ),
    );
  }
}

class _ApplicationCard extends StatelessWidget {
  final Opportunity opportunity;
  const _ApplicationCard({required this.opportunity});

  Color _typeColor(String type) {
    switch (type) {
      case 'Internship':  return const Color(0xFF4A9EFF);
      case 'Hackathon':   return const Color(0xFFFF8C42);
      case 'Workshop':    return const Color(0xFF4CAF50);
      case 'Scholarship': return const Color(0xFF9B6DFF);
      case 'Startup':     return AppColors.primary;
      default:            return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(children: [
        // Type icon
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(
              color: _typeColor(opportunity.type).withOpacity(0.12),
              borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.work_outline_rounded,
              color: _typeColor(opportunity.type), size: 22)),
        const SizedBox(width: 12),
        // Info
        Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(opportunity.title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600, fontSize: 13)),
          const SizedBox(height: 3),
          Text(opportunity.organizer,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.calendar_today_outlined,
                size: 11, color: AppColors.textMuted),
            const SizedBox(width: 4),
            Text('Deadline: ${opportunity.deadline}',
                style: const TextStyle(
                    color: AppColors.textMuted, fontSize: 11)),
          ]),
        ])),
        // Applied badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: const Color(0xFF4CAF50).withOpacity(0.3))),
          child: const Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.check_circle_outline_rounded,
                color: Color(0xFF4CAF50), size: 12),
            SizedBox(width: 4),
            Text('Applied',
                style: TextStyle(color: Color(0xFF4CAF50),
                    fontSize: 11, fontWeight: FontWeight.w700)),
          ])),
      ]),
    );
  }
}