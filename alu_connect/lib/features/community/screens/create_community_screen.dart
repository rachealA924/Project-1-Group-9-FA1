import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../data/community_repository.dart';
import '../models/community.dart';
import '../widgets/community_widgets.dart';
import 'community_created_success_screen.dart';

/// Two-step community creation wizard backed by a single PageView.
class CreateCommunityScreen extends StatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  State<CreateCommunityScreen> createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends State<CreateCommunityScreen> {
  final PageController _pages = PageController();
  final CommunityRepository _repo = CommunityRepository.instance;

  // Step 1 state
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String _category = 'Tech';
  bool _isPrivate = false;

  // Step 2 state
  bool _approvalRequired = true;
  final TextEditingController _invite = TextEditingController(
    text: "Welcome to the group! We're excited to have you join our journey "
        'towards...',
  );
  final List<String> _tags = ['programming', 'design', 'leadership'];
  final Set<String> _selectedPeers = {'Amara Nwosu', 'Kofi Mensah', 'Sarah Tadesse'};

  int _step = 0;

  static const List<String> _categories = [
    'Tech',
    'Arts',
    'Sports',
    'Business',
    'Social',
  ];

  @override
  void dispose() {
    _pages.dispose();
    _name.dispose();
    _description.dispose();
    _invite.dispose();
    super.dispose();
  }

  void _goToStep(int step) {
    setState(() => _step = step);
    _pages.animateToPage(
      step,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _onBack() {
    if (_step == 0) {
      Navigator.of(context).pop();
    } else {
      _goToStep(_step - 1);
    }
  }

  void _launch() {
    final name = _name.text.trim().isEmpty
        ? 'ALU Tech Innovators'
        : _name.text.trim();
    final community = _repo.create(
      name: name,
      category: _category,
      about: _description.text.trim(),
      isPrivate: _isPrivate,
      tags: _tags,
    );
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => CommunityCreatedSuccessScreen(community: community),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _onBack,
        ),
        title: const Text('Create Community',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      ),
      body: Column(
        children: [
          _StepIndicator(step: _step),
          Expanded(
            child: PageView(
              controller: _pages,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _StepOne(
                  nameController: _name,
                  descriptionController: _description,
                  categories: _categories,
                  selectedCategory: _category,
                  onCategory: (c) => setState(() => _category = c),
                  isPrivate: _isPrivate,
                  onVisibility: (p) => setState(() => _isPrivate = p),
                ),
                _StepTwo(
                  approvalRequired: _approvalRequired,
                  onApproval: (v) => setState(() => _approvalRequired = v),
                  inviteController: _invite,
                  tags: _tags,
                  onRemoveTag: (t) => setState(() => _tags.remove(t)),
                  onAddTag: _showAddTag,
                  peers: _repo.suggestedPeers,
                  selectedPeers: _selectedPeers,
                  onTogglePeer: (name) => setState(() {
                    _selectedPeers.contains(name)
                        ? _selectedPeers.remove(name)
                        : _selectedPeers.add(name);
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, 12 + MediaQuery.of(context).padding.bottom),
            child: _step == 0
                ? PrimaryButton(
                    label: 'Next Step',
                    icon: Icons.arrow_forward,
                    onPressed: () => _goToStep(1),
                  )
                : PrimaryButton(
                    label: 'Finish & Launch Community 🚀',
                    onPressed: _launch,
                  ),
          ),
        ],
      ),
    );
  }

  void _showAddTag() {
    final controller = TextEditingController();
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Add Tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'e.g. robotics'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final t = controller.text.trim();
              if (t.isNotEmpty) setState(() => _tags.add(t));
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  const _StepIndicator({required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    const labels = ['Basic Info', 'Members & Access'];
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('STEP ${step + 1} OF 2',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 11,
                    letterSpacing: 1,
                  )),
              Text(labels[step],
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              for (var i = 0; i < 2; i++) ...[
                Expanded(
                  child: Container(
                    height: 5,
                    decoration: BoxDecoration(
                      color: i <= step
                          ? AppColors.primary
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                if (i == 0) const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Step 1 — Basic info
// ---------------------------------------------------------------------------
class _StepOne extends StatelessWidget {
  const _StepOne({
    required this.nameController,
    required this.descriptionController,
    required this.categories,
    required this.selectedCategory,
    required this.onCategory,
    required this.isPrivate,
    required this.onVisibility,
  });

  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final List<String> categories;
  final String selectedCategory;
  final ValueChanged<String> onCategory;
  final bool isPrivate;
  final ValueChanged<bool> onVisibility;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        Center(
          child: Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.border,
                    style: BorderStyle.solid,
                  ),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_a_photo_outlined,
                        color: AppColors.textSecondary),
                    SizedBox(height: 6),
                    Text('Community\nLogo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              const Text('Recommended: 512×512px',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const _FieldLabel('COMMUNITY NAME'),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(
            hintText: 'e.g. Computer Science Innovators',
          ),
        ),
        const SizedBox(height: 18),
        const _FieldLabel('CATEGORY'),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final c in categories)
              PillChip(
                label: c,
                selected: c == selectedCategory,
                onTap: () => onCategory(c),
              ),
          ],
        ),
        const SizedBox(height: 18),
        const _FieldLabel('BRIEF DESCRIPTION'),
        TextField(
          controller: descriptionController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'What is this community about? Share your mission...',
          ),
        ),
        const SizedBox(height: 18),
        _VisibilityTile(
          icon: Icons.public,
          title: 'Public Community',
          subtitle: 'Anyone at ALU can join',
          selected: !isPrivate,
          onTap: () => onVisibility(false),
        ),
        const SizedBox(height: 10),
        _VisibilityTile(
          icon: Icons.lock_outline,
          title: 'Private Community',
          subtitle: 'Requires invite or approval',
          selected: isPrivate,
          onTap: () => onVisibility(true),
        ),
      ],
    );
  }
}

class _VisibilityTile extends StatelessWidget {
  const _VisibilityTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kFieldRadius),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kFieldRadius),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.primary : AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(subtitle,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            _Radio(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _Radio extends StatelessWidget {
  const _Radio({required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? AppColors.primary : AppColors.border,
          width: 2,
        ),
      ),
      child: selected
          ? Center(
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : null,
    );
  }
}

// ---------------------------------------------------------------------------
// Step 2 — Members & access
// ---------------------------------------------------------------------------
class _StepTwo extends StatelessWidget {
  const _StepTwo({
    required this.approvalRequired,
    required this.onApproval,
    required this.inviteController,
    required this.tags,
    required this.onRemoveTag,
    required this.onAddTag,
    required this.peers,
    required this.selectedPeers,
    required this.onTogglePeer,
  });

  final bool approvalRequired;
  final ValueChanged<bool> onApproval;
  final TextEditingController inviteController;
  final List<String> tags;
  final ValueChanged<String> onRemoveTag;
  final VoidCallback onAddTag;
  final List<Peer> peers;
  final Set<String> selectedPeers;
  final ValueChanged<String> onTogglePeer;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
      children: [
        const Text('Member & Access Settings',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 14),
        SurfaceCard(
          child: Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Member Approval Required',
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    SizedBox(height: 2),
                    Text('Review each request to join',
                        style: TextStyle(
                            color: AppColors.textMuted, fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: approvalRequired,
                activeThumbColor: AppColors.onPrimary,
                activeTrackColor: AppColors.primary,
                onChanged: onApproval,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const _FieldLabel('INVITATION MESSAGE'),
        TextField(
          controller: inviteController,
          maxLines: 3,
        ),
        const SizedBox(height: 22),
        const Text('Tags & Interests',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final t in tags)
              PillChip(
                label: '#$t',
                selected: true,
                trailing: GestureDetector(
                  onTap: () => onRemoveTag(t),
                  child: const Icon(Icons.close,
                      size: 14, color: AppColors.onPrimary),
                ),
              ),
            PillChip(label: '+ Add Tag', onTap: onAddTag),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Tags help students discover your community based on shared '
          'interests.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 11.5),
        ),
        const SizedBox(height: 22),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Initial Members',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
            Text('${selectedPeers.length} Selected',
                style: const TextStyle(
                    color: AppColors.primary, fontSize: 12.5)),
          ],
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            hintText: 'Search peers by name or email...',
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
          ),
        ),
        const SizedBox(height: 12),
        for (final peer in peers) ...[
          _PeerTile(
            peer: peer,
            selected: selectedPeers.contains(peer.name),
            onTap: () => onTogglePeer(peer.name),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _PeerTile extends StatelessWidget {
  const _PeerTile({
    required this.peer,
    required this.selected,
    required this.onTap,
  });

  final Peer peer;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(kFieldRadius),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kFieldRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleBadge(
              color: AppColors.primary,
              initials: initialsOf(peer.name),
              size: 40,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(peer.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14)),
                  Text(peer.detail,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 12)),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle : Icons.add_circle_outline,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
