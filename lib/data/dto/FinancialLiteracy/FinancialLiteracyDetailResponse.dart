
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/FinancialLiteracy/CourseVideo.dart';
import '../../../domain/model/FinancialLiteracy/FinancialLiteracyDetail.dart';
import '../../../domain/model/FinancialLiteracy/McqOption.dart';
import '../../../domain/model/FinancialLiteracy/McqQuestion.dart';
import 'FinancialLiteracyItemResponse.dart';

part 'FinancialLiteracyDetailResponse.freezed.dart';
part 'FinancialLiteracyDetailResponse.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DTOs — GET /learn-about-financial  (list)
// ═══════════════════════════════════════════════════════════════════════════════

List<FinancialLiteracyDetailDto> financialLiteracyListFromJson(
    List<dynamic> json) =>
    json.map((x) => FinancialLiteracyDetailDto.fromJson(x as Map<String, dynamic>)).toList();

// ── Detail response (same shape as list item, but includes mcqs) ──────────────
@freezed
abstract class FinancialLiteracyDetailDto with _$FinancialLiteracyDetailDto {
  const FinancialLiteracyDetailDto._();

  const factory FinancialLiteracyDetailDto({
    @JsonKey(name: 'id')                        required int         id,
    @JsonKey(name: 'learnAboutFinancialTitle')   required String      learnAboutFinancialTitle,
    @JsonKey(name: 'learnAboutFinancialSubtitle')required String      learnAboutFinancialSubtitle,
    @JsonKey(name: 'content')                   required String      content,
    @JsonKey(name: 'file')                      String?              file,
    @JsonKey(name: 'thumbnail')                 String?              thumbnail,
    @JsonKey(name: 'title')                     required String      title,
    @JsonKey(name: 'createdAt')                 required DateTime    createdAt,
    @JsonKey(name: 'likesCount')                required int         likesCount,
    // @JsonKey(name: 'isLiked')                   required bool        isLiked,
    // @JsonKey(name: 'isOwner')                   required bool        isOwner,

    // ✅ FIX — ye teen fields detail API response mein nahi hote
    //          required rakha tha → Freezed parse fail → mcqs = []
    @JsonKey(name: 'isLiked')   @Default(false)  bool                 isLiked,
    @JsonKey(name: 'isOwner')   @Default(false)  bool                 isOwner,
    @JsonKey(name: 'userName')                   String?              userName,
    @JsonKey(name: 'videos')
    @Default([]) List<VideoDto>                                       videos,
    @JsonKey(name: 'mcqs')
    @Default([]) List<McqDto>                                         mcqs,
  }) = _FinancialLiteracyDetailDto;

  factory FinancialLiteracyDetailDto.fromJson(Map<String, dynamic> json) =>
      _$FinancialLiteracyDetailDtoFromJson(json);

  /// DTO → Domain
  FinancialLiteracyDetail toDomain() => FinancialLiteracyDetail(
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
    mcqs: mcqs
        .map((q) => McqQuestion(
      id: q.id,
      question: q.question,
      options: q.options
          .map((o) => McqOption(
        id: o.id,
        text: o.text,
        isCorrect: o.isCorrect,
      ))
          .toList(),
    ))
        .toList(),
  );
}

// ── MCQ Option ────────────────────────────────────────────────────────────────
@freezed
abstract class McqOptionDto with _$McqOptionDto {
  const factory McqOptionDto({
    @JsonKey(name: 'id')        required int    id,
    @JsonKey(name: 'text')      required String text,
    @JsonKey(name: 'isCorrect') required bool   isCorrect,
    @JsonKey(name: 'mcqId')     required int    mcqId,
  }) = _McqOptionDto;

  factory McqOptionDto.fromJson(Map<String, dynamic> json) =>
      _$McqOptionDtoFromJson(json);
}

// ── MCQ Question ──────────────────────────────────────────────────────────────
@freezed
abstract class McqDto with _$McqDto {
  const factory McqDto({
    @JsonKey(name: 'id')                     required int           id,
    @JsonKey(name: 'question')               required String        question,
    @JsonKey(name: 'learnAboutFinancialId')  required int           learnAboutFinancialId,
    @JsonKey(name: 'options')
    @Default([]) List<McqOptionDto>                                  options,
  }) = _McqDto;

  factory McqDto.fromJson(Map<String, dynamic> json) =>
      _$McqDtoFromJson(json);
}
