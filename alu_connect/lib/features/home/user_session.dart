import 'package:flutter/material.dart';

/// Central user session — holds logged-in user data across the whole app.
/// Pass it down via constructor or use a simple InheritedWidget approach.
class UserSession extends ChangeNotifier {
  static final UserSession _instance = UserSession._();
  factory UserSession() => _instance;
  UserSession._();

  // User data
  String name        = '';
  String email       = '';
  String campus      = '';   // 'rwanda' | 'mauritius' | 'remote'
  String role        = '';   // 'student' | 'staff' | 'faculty'
  String? avatarPath;        // local asset or file path
  String? googlePhotoUrl;    // from Google OAuth
  List<String> interests = [];
  bool signedInWithGoogle = false;

  // Unread counts (drives notification badges) 
  int unreadMessages       = 2;
  int unreadNotifications  = 3;

  // Derived helpers
  String get displayName => name.isNotEmpty ? name : email.split('@').first;

  String get campusLabel {
    switch (campus) {
      case 'rwanda':    return 'ALU Rwanda · Kigali';
      case 'mauritius': return 'ALC Mauritius · Pamplemousses';
      case 'remote':    return 'ALX Hub · Remote';
      default:          return 'ALU Connect+';
    }
  }

  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (displayName.isNotEmpty) return displayName[0].toUpperCase();
    return 'AU';
  }

  //Setters that notify listeners 
  void setFromLogin({
    required String email,
    String? name,
    String? googlePhotoUrl,
    bool fromGoogle = false,
  }) {
    this.email = email;
    this.name  = name ?? _nameFromEmail(email);
    this.googlePhotoUrl = googlePhotoUrl;
    this.signedInWithGoogle = fromGoogle;
    this.role = _roleFromEmail(email);
    notifyListeners();
  }

  void setOnboarding({required List<String> interests, required String campus}) {
    this.interests = interests;
    this.campus    = campus;
    notifyListeners();
  }

  void updateProfile({String? name, String? avatarPath}) {
    if (name != null) this.name = name;
    if (avatarPath != null) this.avatarPath = avatarPath;
    notifyListeners();
  }

  void markMessagesRead()      { unreadMessages = 0;      notifyListeners(); }
  void markNotificationsRead() { unreadNotifications = 0; notifyListeners(); }
  void addUnreadMessage()      { unreadMessages++;         notifyListeners(); }

  void signOut() {
    name = ''; email = ''; campus = ''; role = '';
    avatarPath = null; googlePhotoUrl = null;
    interests = []; signedInWithGoogle = false;
    unreadMessages = 0; unreadNotifications = 0;
    notifyListeners();
  }

  // Private helpers 
  String _nameFromEmail(String email) {
    final local = email.split('@').first;
    return local.split('.').map((p) =>
        p.isNotEmpty ? '${p[0].toUpperCase()}${p.substring(1)}' : ''
    ).join(' ');
  }

  String _roleFromEmail(String email) {
    final domain = email.split('@').last.toLowerCase();
    if (domain == 'alustudent.com') return 'student';
    if (domain == 'si.alueducation.com') return 'faculty';
    if (domain == 'alueducation.com') return 'staff';
    return 'student';
  }
}