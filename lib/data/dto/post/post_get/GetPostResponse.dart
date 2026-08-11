
// To parse this JSON data, do
//
//     final getPostResponse = getPostResponseFromJson(jsonString);

import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../../domain/model/post/GetPost.dart';

part 'GetPostResponse.freezed.dart';
part 'GetPostResponse.g.dart';

List<GetPostResponse> getPostResponseFromJson(String str) => List<GetPostResponse>.from(json.decode(str).map((x) => GetPostResponse.fromJson(x)));

String getPostResponseToJson(List<GetPostResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

@freezed
abstract class GetPostResponse with _$GetPostResponse {

  // ✅ toDomain() ke liye private constructor zaruri hai
  const GetPostResponse._();

  const factory GetPostResponse({
    @JsonKey(name: "id")
    required int id,
    @JsonKey(name: "title")
    required String title,
    @JsonKey(name: "content")
    required String content,
    @JsonKey(name: "mimeType")
    String? mimeType,
    @JsonKey(name: "category")
    required String category,
    @JsonKey(name: "filePath")
    String? filePath,
    @JsonKey(name: "fileType")
    String? fileType,
    @JsonKey(name: "createdAt")
    required DateTime createdAt,
    @JsonKey(name: "likesCount")
    required int likesCount,
    @JsonKey(name: "userId")
    required int userId,
    @JsonKey(name: "user")
    required User user,
    @JsonKey(name: "isLiked")
    required bool isLiked,
    @JsonKey(name: "isOwner")
    required bool isOwner,
    @JsonKey(name: "userName")
    required String userName,
  }) = _GetPostResponse;

  factory GetPostResponse.fromJson(Map<String, dynamic> json) => _$GetPostResponseFromJson(json);

  GetPost toDomain() {
    return GetPost(
        id: id,
        title: title,
        content: content,
        mimeType: mimeType,
        category: category,
        //filePath: filePath,
        filePath:  _sanitizeUrl(filePath),
        fileType: fileType,
        createdAt: createdAt,
        likesCount: likesCount,
        userId: userId,
        userRole: user.role,
        isLiked: isLiked,
        isOwner: isOwner,
        userName: userName,
        userAvatarUrl: _sanitizeUrl(user.avatar?.mascotUrl),
    );
  }

  String? _sanitizeUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    // ✅ Already complete URL hai
    if (url.startsWith('http://') || url.startsWith('https://')) return url;

    // ✅ FIX: Backend kabhi "nyc3.digitaloceanspaces.com/verveacademy/feed/..."
    // deta hai instead of "verveacademy.nyc3.digitaloceanspaces.com/feed/..."
    // Dono same file hain, bas URL structure alag hai — normalize karo
    if (url.startsWith('nyc3.digitaloceanspaces.com/verveacademy/')) {
      // "nyc3.digitaloceanspaces.com/verveacademy/feed/images/xyz.jpg"
      //  →  "https://verveacademy.nyc3.digitaloceanspaces.com/feed/images/xyz.jpg"
      final path = url.replaceFirst('nyc3.digitaloceanspaces.com/verveacademy/', '');
      return 'https://verveacademy.nyc3.digitaloceanspaces.com/$path';
    }

    // ✅ Koi aur format ho to simply https:// lagao
    return 'https://$url';
  }
}

@freezed
abstract class User with _$User {
  const factory User({
    @JsonKey(name: "name")
    required String name,
    @JsonKey(name: "role")
    required String role,
    @JsonKey(name: "avatar")
    Avatar? avatar,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}


@freezed
abstract class Avatar with _$Avatar {
  const factory Avatar({
    @JsonKey(name: "mascotUrl")
    String? mascotUrl,
  }) = _Avatar;

  factory Avatar.fromJson(Map<String, dynamic> json) => _$AvatarFromJson(json);
}





























