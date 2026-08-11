
import 'dart:io';
import 'package:dio/dio.dart';

class CreatePostRequest {
  final String title;
  final String content;   // HTML string from quill_html_editor
  final String category;
  final File? file;

  CreatePostRequest({
    required this.title,
    required this.content,
    required this.category,
    this.file,
  });

  Future<FormData> toFormData() async {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'category': category,
    };

    if (file != null) {
      map['file'] = await MultipartFile.fromFile(
        file!.path,
        filename: file!.path.split('/').last,
      );
    }

    return FormData.fromMap(map);
  }
}
