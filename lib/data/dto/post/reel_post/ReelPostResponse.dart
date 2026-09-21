
//import '../../../domain/model/reel/ReelPost.dart';

// ✅ NEW — Manual fromJson rakha he (freezed nahi) kyu ki JSON me nested
// "user.avatar.mascotUrl" aur "_count.comments" jaisi nested keys he,
// jo custom parsing maangti he
import '../../../../domain/model/post/ReelPost.dart';

class ReelPostResponse {
  final int      id;
  final String   title;
  final String   content;
  final String?  mimeType;
  final String   category;
  final String?  filePath;
  final String   fileType;
  final DateTime createdAt;
  final int      likesCount;
  final int      userId;
  final String   userName;
  final String?  userAvatarUrl;
  final int      commentsCount;
  final bool     isLiked;
  final bool     isOwner;

  ReelPostResponse({
    required this.id,
    required this.title,
    required this.content,
    this.mimeType,
    required this.category,
    this.filePath,
    required this.fileType,
    required this.createdAt,
    required this.likesCount,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.commentsCount,
    required this.isLiked,
    required this.isOwner,
  });

  factory ReelPostResponse.fromJson(Map<String, dynamic> json) {
    final userJson   = json['user'] as Map<String, dynamic>?;
    final avatarJson = userJson?['avatar'] as Map<String, dynamic>?;
    final countJson  = json['_count'] as Map<String, dynamic>?;

    return ReelPostResponse(
      id:            json['id'] as int,
      title:         json['title'] as String? ?? '',
      content:       json['content'] as String? ?? '',
      mimeType:      json['mimeType'] as String?,
      category:      json['category'] as String? ?? '',
      filePath:      json['filePath'] as String?,
      fileType:      json['fileType'] as String? ?? '',
      createdAt:     DateTime.tryParse(json['createdAt'] as String? ?? '') ?? DateTime.now(),
      likesCount:    (json['likesCount'] as num?)?.toInt() ?? 0,
      userId:        (json['userId'] as num?)?.toInt() ?? 0,
      userName:      json['userName'] as String? ?? (userJson?['name'] as String? ?? ''),
      userAvatarUrl: avatarJson?['mascotUrl'] as String?,
      commentsCount: (json['commentsCount'] as num?)?.toInt()
          ?? (countJson?['comments'] as num?)?.toInt()
          ?? 0,
      isLiked:  json['isLiked'] as bool? ?? false,
      isOwner:  json['isOwner'] as bool? ?? false,
    );
  }

  ReelPost toDomain() => ReelPost(
    id: id,
    title: title,
    content: content,
    filePath: filePath,
    fileType: fileType,
    category: category,
    createdAt: createdAt,
    likesCount: likesCount,
    userId: userId,
    userName: userName,
    userAvatarUrl: userAvatarUrl,
    commentsCount: commentsCount,
    isLiked: isLiked,
    isOwner: isOwner,
  );
}