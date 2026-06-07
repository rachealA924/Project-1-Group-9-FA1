import 'package:flutter/material.dart';

/// A campus community / club students can browse, join and create.
class Community {
  Community({
    required this.id,
    required this.name,
    required this.tagline,
    required this.about,
    required this.category,
    required this.memberCount,
    required this.accentColor,
    required this.icon,
    this.tags = const [],
    this.events = const [],
    this.announcements = const [],
    this.posts = const [],
    this.isJoined = false,
    this.isOfficial = false,
    this.isPrivate = false,
  });

  final String id;
  final String name;
  final String tagline;
  final String about;
  final String category;
  final int memberCount;

  /// Stand-in for a cover image until real assets are wired up.
  final Color accentColor;
  final IconData icon;

  final List<String> tags;
  final List<CommunityEvent> events;
  final List<Announcement> announcements;
  final List<DiscussionPost> posts;

  bool isJoined;
  final bool isOfficial;
  final bool isPrivate;
}

/// An upcoming event shown on a community's detail page.
class CommunityEvent {
  const CommunityEvent({
    required this.month,
    required this.day,
    required this.title,
    required this.location,
    required this.time,
  });

  final String month; // e.g. "DEC"
  final String day; // e.g. "12"
  final String title;
  final String location;
  final String time;
}

/// A pinned announcement from an admin / faculty advisor.
class Announcement {
  const Announcement({
    required this.author,
    required this.role,
    required this.timeAgo,
    required this.body,
    this.title,
    this.likes = 0,
    this.comments = 0,
    this.attachmentName,
    this.attachmentSize,
  });

  final String author;
  final String role;
  final String timeAgo;
  final String? title;
  final String body;
  final int likes;
  final int comments;
  final String? attachmentName;
  final String? attachmentSize;
}

/// A message in a community's discussion feed.
class DiscussionPost {
  const DiscussionPost({
    required this.author,
    required this.timeAgo,
    required this.message,
    this.role,
    this.likes = 0,
    this.comments = 0,
    this.verified = false,
  });

  final String author;
  final String? role;
  final String timeAgo;
  final String message;
  final int likes;
  final int comments;
  final bool verified;
}

/// A peer that can be added as an initial member when creating a community.
class Peer {
  const Peer({required this.name, required this.detail});
  final String name;
  final String detail;
}

/// Shared helper: turn a full name into up-to-two-letter initials.
String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '?';
  if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
  return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
      .toUpperCase();
}
