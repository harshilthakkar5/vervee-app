
// ─── Helper: UpdatePostRequest (FormData builder) ─────────────────────────────
// File: lib/features/post/data/models/update_post_request.dart
//
// CreatePostRequest jaise hi structure — PATCH ke liye use hota hai.
// File optional hai; agar user ne naya image nahi select kiya toh sirf
// text fields update honge.

import 'dart:io';
import 'package:dio/dio.dart';

class UpdatePostRequest {
  final String? title;
  final String? content;
  final String? category;
  final File?   file;

  const UpdatePostRequest({
    this.title,
    this.content,
    this.category,
    this.file,
  });

  Future<FormData> toFormData() async {
    final fields = <String, dynamic>{};

    // ✅ Sirf jo fields provided hain unhe bhejo
    if (title    != null) fields['title']    = title!;
    if (content  != null) fields['content']  = content!;
    if (category != null) fields['category'] = category!;

    if (file != null) {
      fields['file'] = await MultipartFile.fromFile(
        file!.path,
        filename: file!.path.split('/').last,
      );
    }

    return FormData.fromMap(fields);
  }
}

// class UpdatePostRequest {
//   final String  title;
//   final String  content;
//   final String  category;
//   final File?   file;
//
//   const UpdatePostRequest({
//     required this.title,
//     required this.content,
//     required this.category,
//     this.file,
//   });
//
//   Future<FormData> toFormData() async {
//     final fields = <String, dynamic>{
//       'title':    title,
//       'content':  content,
//       'category': category,
//     };
//
//     // ✅ File optional hai — agar nahi chuni toh include mat karo
//     if (file != null) {
//       final fileName = file!.path.split('/').last;
//       fields['file'] = await MultipartFile.fromFile(
//         file!.path,
//         filename: fileName,
//       );
//     }
//
//     return FormData.fromMap(fields);
//   }
// }





























