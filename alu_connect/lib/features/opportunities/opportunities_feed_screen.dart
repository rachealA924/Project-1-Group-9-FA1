import 'package:flutter/material.dart';
import 'data/opportunities_data.dart';
import 'models/opportunity_model.dart';
import 'opportunity_detail_screen.dart';

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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('Opportunities', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            color: const Color(0xFF1A1A2E),
            padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: filters.map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (_) => setState(() => selectedFilter = filter),
                      selectedColor: const Color(0xFFE94560),
                      backgroundColor: Colors.white24,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: filteredOpportunities.isEmpty
                ? const Center(child: Text('No opportunities found.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredOpportunities.length,
                    itemBuilder: (context, index) {
                      final opp = filteredOpportunities[index];
                      return _OpportunityCard(
                        opportunity: opp,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OpportunityDetailScreen(opportunity: opp),
                          ),
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
      case 'Startup': return const Color(0xFFE94560);
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                opportunity.imageUrl,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 130,
                  color: const Color(0xFF1A1A2E),
                  child: const Icon(Icons.image, color: Colors.white54, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  Text(opportunity.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 4),
                  Text(opportunity.organizer, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Deadline: ${opportunity.deadline}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const Spacer(),
                      const Icon(Icons.location_on, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(opportunity.location, style: const TextStyle(fontSize: 12, color: Colors.grey)),
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