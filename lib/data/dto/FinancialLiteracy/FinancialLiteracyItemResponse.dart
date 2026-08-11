
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/FinancialLiteracy/CourseVideo.dart';
import '../../../domain/model/FinancialLiteracy/FinancialLiteracyCourse.dart';

part 'FinancialLiteracyItemResponse.freezed.dart';
part 'FinancialLiteracyItemResponse.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DTOs — GET /learn-about-financial  (list)
// ═══════════════════════════════════════════════════════════════════════════════

List<FinancialLiteracyItemDto> financialLiteracyListFromJson(
    List<dynamic> json) =>
    json.map((x) => FinancialLiteracyItemDto.fromJson(x as Map<String, dynamic>)).toList();

// ── Course item (list response) ───────────────────────────────────────────────
@freezed
abstract class FinancialLiteracyItemDto with _$FinancialLiteracyItemDto {
  const FinancialLiteracyItemDto._();

  const factory FinancialLiteracyItemDto({
    @JsonKey(name: 'id')                        required int         id,
    @JsonKey(name: 'learnAboutFinancialTitle')   required String      learnAboutFinancialTitle,
    @JsonKey(name: 'learnAboutFinancialSubtitle')required String      learnAboutFinancialSubtitle,
    @JsonKey(name: 'content')                   required String      content,
    @JsonKey(name: 'file')                      String?              file,
    @JsonKey(name: 'thumbnail')                 String?              thumbnail,
    @JsonKey(name: 'title')                     required String      title,
    @JsonKey(name: 'createdAt')                 required DateTime    createdAt,
    @JsonKey(name: 'likesCount')                required int         likesCount,
    @JsonKey(name: 'isLiked')                   required bool        isLiked,
    @JsonKey(name: 'isOwner')                   required bool        isOwner,
    @JsonKey(name: 'videos')
    @Default([]) List<VideoDto>                                       videos,
  }) = _FinancialLiteracyItemDto;

  factory FinancialLiteracyItemDto.fromJson(Map<String, dynamic> json) =>
      _$FinancialLiteracyItemDtoFromJson(json);

  /// DTO → Domain
  FinancialLiteracyCourse toDomain() => FinancialLiteracyCourse(
    id: id,
    title: title,
    subtitle: learnAboutFinancialSubtitle,
    content: content,
    thumbnail: thumbnail,
    createdAt: createdAt,
    likesCount: likesCount,
    isLiked: isLiked,
    isOwner: isOwner,
    videos: videos
        .map((v) => CourseVideo(
      id: v.id,
      title: v.title,
      content: v.content,
      videoUrl: v.contentUpload,
    ))
        .toList(),
  );
}

// ── Video inside a course ─────────────────────────────────────────────────────
@freezed
abstract class VideoDto with _$VideoDto {
  const factory VideoDto({
    @JsonKey(name: 'id')       required int    id,
    @JsonKey(name: 'title')    required String title,
    @JsonKey(name: 'content')  required String content,
    @JsonKey(name: 'learnAboutFinancialId') required int learnAboutFinancialId,
    @JsonKey(name: 'contentUpload') String? contentUpload,
  }) = _VideoDto;

  factory VideoDto.fromJson(Map<String, dynamic> json) =>
      _$VideoDtoFromJson(json);
}






























