import 'package:flutter/material.dart';
import 'data/opportunities_data.dart';
import 'models/opportunity_model.dart';
import 'opportunity_detail_screen.dart';
import '../../theme/app_theme.dart';

class OpportunitiesFeedScreen extends StatefulWidget {
  const OpportunitiesFeedScreen({super.key});

  @override
  State<OpportunitiesFeedScreen> createState() => _OpportunitiesFeedScreenState();
}

class _OpportunitiesFeedScreenState extends State<OpportunitiesFeedScreen> {
  String selectedFilter = 'All';
  final List<String> filters = ['All', 'Internship', 'Hackathon', 'Workshop', 'Scholarship', 'Startup'];

  List<Opportunity> get filteredOpportunities {
    if (selectedFilter == 'All') return mockOpportunities;
    return mockOpportunities.where((o) => o.type == selectedFilter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: const Text('Opportunities', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedFilter = filter),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
                        ),
                        child: Text(
                          filter,
                          style: TextStyle(
                            color: isSelected ? AppColors.onPrimary : AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // List
          Expanded(
            child: filteredOpportunities.isEmpty
                ? const Center(
                    child: Text('No opportunities found.', style: TextStyle(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredOpportunities.length,
                    itemBuilder: (context, index) {
                      final opp = filteredOpportunities[index];
                      return _OpportunityCard(
                        opportunity: opp,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => OpportunityDetailScreen(opportunity: opp)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _OpportunityCard extends StatelessWidget {
  final Opportunity opportunity;
  final VoidCallback onTap;

  const _OpportunityCard({required this.opportunity, required this.onTap});

  Color _typeColor(String type) {
    switch (type) {
      case 'Internship': return Colors.blue;
      case 'Hackathon': return Colors.orange;
      case 'Workshop': return Colors.green;
      case 'Scholarship': return Colors.purple;
      case 'Startup': return AppColors.primary;
      default: return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(kCardRadius)),
              child: Image.network(
                opportunity.imageUrl,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  color: AppColors.surfaceVariant,
                  child: const Icon(Icons.image, color: AppColors.textMuted, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Type badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _typeColor(opportunity.type).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      opportunity.type,
                      style: TextStyle(color: _typeColor(opportunity.type), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(opportunity.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(opportunity.organizer, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text('Deadline: ${opportunity.deadline}', style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                      const Spacer(),
                      const Icon(Icons.location_on, size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(opportunity.location, style: const TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}