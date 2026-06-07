import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../models/community.dart';
import '../widgets/community_widgets.dart';
import 'community_discussion_screen.dart';

/// Celebration screen shown after a community is launched.
class CommunityCreatedSuccessScreen extends StatelessWidget {
  const CommunityCreatedSuccessScreen({super.key, required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: const Icon(Icons.campaign_outlined,
                    size: 46, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(
                'Community Launched!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10),
              Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    height: 1.5,
                    fontSize: 14,
                  ),
                  children: [
                    const TextSpan(text: 'Your community '),
                    TextSpan(
                      text: community.name,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const TextSpan(
                      text: ' is now live. Time to start the conversation!',
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              _SummaryCard(community: community),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _SecondaryButton(
                      icon: Icons.share_outlined,
                      label: 'Share Link',
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Invite link copied')),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _SecondaryButton(
                      icon: Icons.person_add_alt,
                      label: 'Invite More',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Go to My Community Hub',
                icon: Icons.arrow_forward,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) =>
                          CommunityDiscussionScreen(community: community),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.community});

  final Community community;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          Row(
            children: [
              CircleBadge(
                color: community.accentColor,
                icon: community.icon,
                size: 46,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(community.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15)),
                    Text(community.category,
                        style: const TextStyle(
                            color: AppColors.textMuted, fontSize: 12.5)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              const Expanded(
                child: _Metric(
                  label: 'INITIAL REACH',
                  value: '1 Member (You)',
                ),
              ),
              Container(width: 1, height: 32, color: AppColors.border),
              const Expanded(
                child: _Metric(
                  label: 'STATUS',
                  value: 'Live',
                  valueColor: AppColors.online,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 10.5,
                letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: valueColor ?? AppColors.textPrimary,
            )),
      ],
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppColors.textPrimary),
      label: Text(label,
          style: const TextStyle(
              color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kFieldRadius),
        ),
      ),
    );
  }
}
