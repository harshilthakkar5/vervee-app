
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:convert';

import '../../../../domain/model/post/CreatePost.dart';

part 'CreatePostResponse.freezed.dart';
part 'CreatePostResponse.g.dart';

CreatePostResponse createPostResponseFromJson(String str) => CreatePostResponse.fromJson(json.decode(str));

String createPostResponseToJson(CreatePostResponse data) => json.encode(data.toJson());

@freezed
abstract class CreatePostResponse with _$CreatePostResponse {

  // ✅ toDomain() ke liye private constructor zaruri hai
  const CreatePostResponse._();

  const factory CreatePostResponse({
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
  }) = _CreatePostResponse;

  factory CreatePostResponse.fromJson(Map<String, dynamic> json,) => _$CreatePostResponseFromJson(json);

  CreatePost toDomain() {
    return CreatePost(
      id: id,
      title: title,
      content: content,
      category: category,
      createdAt: createdAt.toString(),
      likesCount: likesCount,
      userId: userId,
      // filePath: filePath,
      // ✅ FIX: filePath mein https:// missing ho to add karo
      filePath: _sanitizeUrl(filePath),
      fileType: fileType,
      mimeType: mimeType,
    );
  }

  // ✅ Backend kabhi kabhi https:// ke bina URL deta hai — yahan fix karo
  // String? _sanitizeUrl(String? url) {
  //   if (url == null || url.isEmpty) return null;
  //   if (url.startsWith('http://') || url.startsWith('https://')) return url;
  //   // ✅ Sirf domain se shuru ho to https:// prefix lagao
  //   return 'https://$url';
  // }

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


// @freezed
// class CreatePostResponse with _$CreatePostResponse {
//   const factory CreatePostResponse({
//     @JsonKey(name: "id")
//     required int id,
//     @JsonKey(name: "title")
//     required String title,
//     @JsonKey(name: "content")
//     required String content,
//     @JsonKey(name: "mimeType")
//     required String mimeType,
//     @JsonKey(name: "category")
//     required String category,
//     @JsonKey(name: "filePath")
//     required String filePath,
//     @JsonKey(name: "fileType")
//     required String fileType,
//     @JsonKey(name: "createdAt")
//     required DateTime createdAt,
//     @JsonKey(name: "likesCount")
//     required int likesCount,
//     @JsonKey(name: "userId")
//     required int userId,
//   }) = _CreatePostResponse;
//
//   factory CreatePostResponse.fromJson(Map<String, dynamic> json) => _$CreatePostResponseFromJson(json);
// }


























