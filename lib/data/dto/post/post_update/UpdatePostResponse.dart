
// update_post_response.dart

// import 'package:freezed_annotation/freezed_annotation.dart';
// import 'dart:convert';
//
// part 'UpdatePostResponse.freezed.dart';
// part 'UpdatePostResponse.g.dart';
//
// UpdatePostResponse updatePostResponseFromJson(String str) => UpdatePostResponse.fromJson(json.decode(str));
//
// String updatePostResponseToJson(UpdatePostResponse data) => json.encode(data.toJson());
//
// @freezed
// abstract class UpdatePostResponse with _$UpdatePostResponse {
//
//   const UpdatePostResponse._();
//
//   const factory UpdatePostResponse({
//     @JsonKey(name: "id")
//     required int id,
//     @JsonKey(name: "title")
//     required String title,
//     @JsonKey(name: "content")
//     required String content,
//     @JsonKey(name: "mimeType")
//     String? mimeType,
//     @JsonKey(name: "category")
//     String? category,
//     @JsonKey(name: "filePath")
//     String? filePath,
//     @JsonKey(name: "fileType")
//     String? fileType,
//     @JsonKey(name: "createdAt")
//     required DateTime createdAt,
//     @JsonKey(name: "likesCount")
//     required int likesCount,
//     @JsonKey(name: "userId")
//     required int userId,
//   }) = _UpdatePostResponse;
//
//   factory UpdatePostResponse.fromJson(Map<String, dynamic> json) =>
//       _$UpdatePostResponseFromJson(json);
//
//   GetUpdatedPost toDomain() => GetUpdatedPost(
//       id: id,
//       title: title,
//       content: content,
//       mimeType: mimeType,
//       category: category,
//       filePath: filePath,
//       fileType: fileType,
//       createdAt: createdAt,
//       likesCount: likesCount,
//       userId: userId,
//   );
// }