import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';
import '../models/community.dart';

/// Full-width golden CTA used across the community flow.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Icon(icon, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}

/// Selectable pill (category filters, tags, visibility chips).
class PillChip extends StatelessWidget {
  const PillChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.primary : AppColors.surfaceVariant,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected ? AppColors.primary : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: selected ? AppColors.onPrimary : AppColors.textSecondary,
                ),
              ),
              if (trailing != null) ...[const SizedBox(width: 6), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}

/// "Section title" + optional trailing action (e.g. "See All").
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
      ],
    );
  }
}

/// Circular avatar that falls back to initials over a colored disc.
class CircleBadge extends StatelessWidget {
  const CircleBadge({
    super.key,
    required this.color,
    this.icon,
    this.initials,
    this.size = 44,
  });

  final Color color;
  final IconData? icon;
  final String? initials;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      alignment: Alignment.center,
      child: icon != null
          ? Icon(icon, color: color, size: size * 0.45)
          : Text(
              initials ?? '?',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: size * 0.36,
              ),
            ),
    );
  }
}

/// A community row card used in the hub list ("Join" CTA on the right).
class CommunityListCard extends StatelessWidget {
  const CommunityListCard({
    super.key,
    required this.community,
    required this.onJoinToggle,
    required this.onOpen,
  });

  final Community community;
  final VoidCallback onJoinToggle;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(kCardRadius),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(kCardRadius),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            CircleBadge(color: community.accentColor, icon: community.icon),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    community.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    community.about,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.5,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.people_outline,
                          size: 14, color: AppColors.textMuted),
                      const SizedBox(width: 4),
                      Text(
                        '${community.memberCount} Members',
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            _JoinButton(joined: community.isJoined, onTap: onJoinToggle),
          ],
        ),
      ),
    );
  }
}

class _JoinButton extends StatelessWidget {
  const _JoinButton({required this.joined, required this.onTap});

  final bool joined;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: joined ? Colors.transparent : AppColors.primary,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: joined ? AppColors.border : AppColors.primary,
          ),
        ),
        child: Text(
          joined ? 'Joined' : 'Join',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 13,
            color: joined ? AppColors.textSecondary : AppColors.onPrimary,
          ),
        ),
      ),
    );
  }
}

/// Small rounded surface used to wrap richer sections (about, events…).
class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(kCardRadius),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}

/// Tiny like / comment counter row reused in feeds.
class EngagementRow extends StatelessWidget {
  const EngagementRow({super.key, required this.likes, required this.comments});

  final int likes;
  final int comments;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.favorite_border, size: 17, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Text('$likes',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
        const SizedBox(width: 18),
        const Icon(Icons.mode_comment_outlined,
            size: 16, color: AppColors.textMuted),
        const SizedBox(width: 5),
        Text('$comments',
            style: const TextStyle(color: AppColors.textMuted, fontSize: 12.5)),
        const Spacer(),
        const Icon(Icons.share_outlined, size: 16, color: AppColors.textMuted),
      ],
    );
  }
}

/// Static 5-tab bottom navigation matching the design (only People is wired).
class AluBottomNav extends StatelessWidget {
  const AluBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textMuted,
      type: BottomNavigationBarType.fixed,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.explore_outlined), label: 'Discover'),
        BottomNavigationBarItem(
            icon: Icon(Icons.groups_outlined), label: 'People'),
        BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline), label: 'Messages'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), label: 'Profile'),
      ],
    );
  }
}

/// Author header (avatar + name + role · time) used in posts/announcements.
class AuthorHeader extends StatelessWidget {
  const AuthorHeader({
    super.key,
    required this.name,
    required this.subtitle,
    this.color = AppColors.primary,
    this.verified = false,
  });

  final String name;
  final String subtitle;
  final Color color;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleBadge(color: color, initials: initialsOf(name), size: 38),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      name,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  if (verified) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.verified,
                        size: 14, color: AppColors.verified),
                  ],
                ],
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        const Icon(Icons.more_horiz, color: AppColors.textMuted),
      ],
    );
  }
}
