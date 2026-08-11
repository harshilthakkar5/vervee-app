
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../domain/model/profile/UserFeedPost.dart';
//import '../../domain/models/profile_domain.dart';

part 'UserFeedPostResponse.freezed.dart';
part 'UserFeedPostResponse.g.dart';

@freezed
abstract class UserFeedPostResponse with _$UserFeedPostResponse {
  const UserFeedPostResponse._();

  const factory UserFeedPostResponse({
    @JsonKey(name: 'id')        required int      id,
    @JsonKey(name: 'title')     required String   title,
    @JsonKey(name: 'content')   required String   content,
    @JsonKey(name: 'mimeType')  String?           mimeType,
    @JsonKey(name: 'category')  required String   category,
    @JsonKey(name: 'filePath')  String?           filePath,
    @JsonKey(name: 'fileType')  String?           fileType,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'likesCount') required int     likesCount,
    @JsonKey(name: 'userId')    required int      userId,
    @JsonKey(name: 'isLiked')   required bool     isLiked,
  }) = _UserFeedPostResponse;

  factory UserFeedPostResponse.fromJson(Map<String, dynamic> json) =>
      _$UserFeedPostResponseFromJson(json);

  UserFeedPost toDomain() => UserFeedPost(
    id: id,
    title: title,
    content: content,
    category: category,
    filePath: _sanitizeUrl(filePath),
    fileType: fileType,
    mimeType: mimeType,
    createdAt: createdAt,
    likesCount: likesCount,
    userId: userId,
    isLiked: isLiked,
  );
}

// Helper function — list parse karne ke liye (getPostResponseFromJson jaisi)
List<UserFeedPostResponse> userFeedPostResponseFromJson(
    List<dynamic> list) =>
    list.map((e) => UserFeedPostResponse.fromJson(e)).toList();

// Helper: GetPostResponse._sanitizeUrl jaisi tarah URL fix karo
String? _sanitizeUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  if (url.startsWith('nyc3.digitaloceanspaces.com/verveacademy/')) {
    final path = url.replaceFirst(
        'nyc3.digitaloceanspaces.com/verveacademy/', '');
    return 'https://verveacademy.nyc3.digitaloceanspaces.com/$path';
  }
  return 'https://$url';
}
