
import 'package:hive/hive.dart';

import '../domain/model/profile/UserProfile.dart';
import '../domain/model/profile/UserFeedPost.dart';
import '../domain/model/profile/SubscriptionInfo.dart';

/// ProfileCacheService — ProfileScreen ka data Hive mein cache karta hai
/// AuthService jaisa hi singleton pattern
class ProfileCacheService {
  ProfileCacheService._();
  static final ProfileCacheService instance = ProfileCacheService._();

  static const _boxName = 'profile_cache_box';
  static const _kProfile      = 'profile';
  static const _kFeed         = 'feed_posts';
  static const _kSubscription = 'subscription';

  Box? _box;

  /// main.dart mein app start hote hi ek baar call karo
  Future<void> init() async {
    _box ??= await Hive.openBox(_boxName);
  }

  Box get _safeBox {
    final box = _box;
    if (box == null) {
      throw StateError(
          'ProfileCacheService.init() call nahi hua — main.dart check karo');
    }
    return box;
  }
  //
  // // ── UserProfile ──────────────────────────────────────────────────
  // Future<void> saveProfile(UserProfile profile) => _safeBox.put(_kProfile, {
  //   'id': profile.id,
  //   'name': profile.name,
  //   'email': profile.email,
  //   'role': profile.role,
  // });
  //
  // UserProfile? getProfile() {
  //   final raw = _safeBox.get(_kProfile);
  //   if (raw == null) return null;
  //   final m = Map<String, dynamic>.from(raw as Map);
  //   return UserProfile(
  //     id: m['id'] as int,
  //     name: m['name'] as String,
  //     email: m['email'] as String,
  //     role: m['role'] as String,
  //   );
  // }

  bool get isReady => _box != null;   // ✅ ADD — debug ke liye check karne ka tareeka

  // ── UserProfile ──────────────────────────────────────────────────
  Future<void> saveProfile(UserProfile profile) async {
    if (_box == null) return;   // ✅ box abhi ready nahi to silently skip
    await _box!.put(_kProfile, {
      'id': profile.id,
      'name': profile.name,
      'email': profile.email,
      'role': profile.role,
    });
  }

  UserProfile? getProfile() {
    if (_box == null) return null;   // ✅ crash nahi, graceful null
    final raw = _box!.get(_kProfile);
    if (raw == null) return null;
    final m = Map<String, dynamic>.from(raw as Map);
    return UserProfile(
      id: m['id'] as int,
      name: m['name'] as String,
      email: m['email'] as String,
      role: m['role'] as String,
    );
  }

  // ── UserFeedPost list ────────────────────────────────────────────
  Future<void> saveFeed(List<UserFeedPost> posts) => _safeBox.put(
    _kFeed,
    posts.map((p) => {
      'id': p.id,
      'title': p.title,
      'content': p.content,
      'category': p.category,
      'filePath': p.filePath,
      'fileType': p.fileType,
      'mimeType': p.mimeType,
      'createdAt': p.createdAt.toIso8601String(),
      'likesCount': p.likesCount,
      'userId': p.userId,
      'isLiked': p.isLiked,
    }).toList(),
  );

  List<UserFeedPost> getFeed() {
    final raw = _safeBox.get(_kFeed);
    if (raw == null) return [];
    return (raw as List).map((e) {
      final m = Map<String, dynamic>.from(e as Map);
      return UserFeedPost(
        id: m['id'] as int,
        title: m['title'] as String,
        content: m['content'] as String,
        category: m['category'] as String,
        filePath: m['filePath'] as String?,
        fileType: m['fileType'] as String?,
        mimeType: m['mimeType'] as String?,
        createdAt: DateTime.parse(m['createdAt'] as String),
        likesCount: m['likesCount'] as int,
        userId: m['userId'] as int,
        isLiked: m['isLiked'] as bool,
      );
    }).toList();
  }

  // ── SubscriptionInfo ─────────────────────────────────────────────
  Future<void> saveSubscription(SubscriptionInfo info) =>
      _safeBox.put(_kSubscription, {
        'status': info.status,
        'trialEnd': info.trialEnd?.toIso8601String(),
        'cancelAtPeriodEnd': info.cancelAtPeriodEnd,
      });

  SubscriptionInfo? getSubscription() {
    final raw = _safeBox.get(_kSubscription);
    if (raw == null) return null;
    final m = Map<String, dynamic>.from(raw as Map);
    return SubscriptionInfo(
      status: m['status'] as String,
      trialEnd: m['trialEnd'] != null
          ? DateTime.parse(m['trialEnd'] as String)
          : null,
      cancelAtPeriodEnd: m['cancelAtPeriodEnd'] as bool,
    );
  }

  // ── Logout pe sab clear ───────────────────────────────────────────
  Future<void> clearAll() => _safeBox.clear();
}