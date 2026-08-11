
// ─── FILE: lib/utils/PostCacheService.dart ───────────────────────────────────
// Kaam: GetPostResponse ka JSON cache karta hai SharedPreferences me
// GetPostResponse already fromJson/toJson support karta hai (retrofit generated)
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

// ✅ GetPostResponse import karo — yahi toJson/fromJson support karta hai
import '../data/dto/post/post_get/GetPostResponse.dart';
import '../domain/model/post/GetPost.dart';

class PostCacheService {

  // ── Cache keys ──────────────────────────────────────────────────────────────
  // Category ke hisaab se alag key — "All", "Crypto", etc.
  static String _postsKey(String category)      => 'posts_cache_$category';
  static String _timestampKey(String category)  => 'posts_ts_$category';

  // ✅ Cache 30 minute valid rahega
  static const Duration _validity = Duration(minutes: 30);

  // ── Posts save karo ─────────────────────────────────────────────────────────
  // API response aane ke baad call karo
  // GetPostResponse list pass karo — yeh toJson support karta hai
  static Future<void> savePosts({
    required List<GetPost>  posts,
    required String         category,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // ✅ GetPost → Map → JSON string
      // GetPost freezed hai — manually Map banate hain
      final jsonList = posts.map((p) => {
        'id':         p.id,
        'title':      p.title,
        'content':    p.content,
        'mimeType':   p.mimeType,
        'category':   p.category,
        'filePath':   p.filePath,
        'fileType':   p.fileType,
        'createdAt':  p.createdAt.toIso8601String(),
        'likesCount': p.likesCount,
        'userId':     p.userId,
        'userRole':   p.userRole,
        'isLiked':    p.isLiked,
        'isOwner':    p.isOwner,
        'userName':   p.userName,
      }).toList();

      await prefs.setString(_postsKey(category), jsonEncode(jsonList));
      await prefs.setInt(
        _timestampKey(category),
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (_) {
      // Cache save fail ho toh silently ignore karo
    }
  }

  // ── Cached posts load karo ───────────────────────────────────────────────────
  // App open hone par call karo — null return = cache nahi hai
  static Future<List<GetPost>?> loadPosts(String category) async {
    try {
      final prefs      = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_postsKey(category));
      if (jsonString == null) return null;

      final jsonList = jsonDecode(jsonString) as List;

      // ✅ Map → GetPost manually reconstruct karo
      return jsonList.map((json) {
        final map = json as Map<String, dynamic>;
        return GetPost(
          id:         map['id']         as int,
          title:      map['title']      as String,
          content:    map['content']    as String,
          mimeType:   map['mimeType']   as String?,
          category:   map['category']   as String,
          filePath:   map['filePath']   as String?,
          fileType:   map['fileType']   as String?,
          createdAt:  DateTime.parse(map['createdAt'] as String),
          likesCount: map['likesCount'] as int,
          userId:     map['userId']     as int,
          userRole:   map['userRole']   as String,
          isLiked:    map['isLiked']    as bool,
          isOwner:    map['isOwner']    as bool,
          userName:   map['userName']   as String,
        );
      }).toList();
    } catch (_) {
      return null;
    }
  }

  // ── Cache valid hai ya nahi ──────────────────────────────────────────────────
  static Future<bool> isCacheValid(String category) async {
    try {
      final prefs     = await SharedPreferences.getInstance();
      final timestamp = prefs.getInt(_timestampKey(category));
      if (timestamp == null) return false;

      final saved = DateTime.fromMillisecondsSinceEpoch(timestamp);
      return DateTime.now().difference(saved) < _validity;
    } catch (_) {
      return false;
    }
  }

  // ── Cache clear karo — logout ya force refresh pe ───────────────────────────
  static Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys  = prefs.getKeys();
      for (final key in keys) {
        if (key.startsWith('posts_cache_') || key.startsWith('posts_ts_')) {
          await prefs.remove(key);
        }
      }
    } catch (_) {}
  }
}