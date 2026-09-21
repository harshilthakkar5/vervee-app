

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/FinancialLiteracy/McqOption.dart';
import '../../../domain/model/FinancialLiteracy/McqQuestion.dart';
//import '../../../domain/model/VerveeUniverse/UniverseChapter.dart';
//import '../../../domain/model/VerveeUniverse/VerveeUniverseDetail.dart';
import '../../../domain/model/VerveeUniverse/UniverseChapter.dart';
import '../../../domain/model/VerveeUniverse/VerveeUniverseDetail.dart';
import 'VerveeUniverseItemResponse.dart'; // UniverseVideoDto

part 'VerveeUniverseDetailResponse.freezed.dart';
part 'VerveeUniverseDetailResponse.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DTOs — GET /vervee-universe/{id}  (detail — chapters carry mcqs too)
// ═══════════════════════════════════════════════════════════════════════════════

// ── Detail response (same shape as list item) ──────────────────────────────────
@freezed
abstract class VerveeUniverseDetailDto with _$VerveeUniverseDetailDto {
  const VerveeUniverseDetailDto._();

  const factory VerveeUniverseDetailDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'verveeUniverseTitle') required String verveeUniverseTitle,
    @JsonKey(name: 'verveeUniverseSubtitle')
    @Default('') String verveeUniverseSubtitle,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'thumbnail') String? thumbnail,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'likesCount') @Default(0) int likesCount,

    // ✅ FIX — detail response me ye fields (list ke ulat) missing hote he,
    //          isliye required nahi — default rakha he (FinancialLiteracy
    //          flow me bhi yahi fix pehle kiya gaya tha)
    @JsonKey(name: 'isLiked') @Default(false) bool isLiked,
    @JsonKey(name: 'isOwner') @Default(false) bool isOwner,
    @JsonKey(name: 'userName') String? userName,

    @JsonKey(name: 'chapters')
    @Default([]) List<UniverseChapterDetailDto> chapters,
  }) = _VerveeUniverseDetailDto;

  factory VerveeUniverseDetailDto.fromJson(Map<String, dynamic> json) =>
      _$VerveeUniverseDetailDtoFromJson(json);

  /// DTO → Domain
  VerveeUniverseDetail toDomain() => VerveeUniverseDetail(
    id: id,
    title: title,
    subtitle: verveeUniverseSubtitle,
    content: content,
    thumbnail: thumbnail,
    createdAt: createdAt,
    likesCount: likesCount,
    isLiked: isLiked,
    isOwner: isOwner,
    chapters: chapters.map((c) => c.toDomain()).toList(),
  );
}

// ── Chapter inside detail response (video + iske apne mcqs) ────────────────────
@freezed
abstract class UniverseChapterDetailDto with _$UniverseChapterDetailDto {
  const UniverseChapterDetailDto._();

  const factory UniverseChapterDetailDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'order') @Default(1) int order,
    @JsonKey(name: 'verveeUniverseId') int? verveeUniverseId,
    @JsonKey(name: 'video') UniverseVideoDto? video,
    @JsonKey(name: 'mcqs') @Default([]) List<UniverseMcqDto> mcqs,
    // NOTE: response me "quizAttempts" bhi aata he — filhaal app isko use
    // nahi karta, isliye yahan map nahi kiya (Freezed extra keys ignore kar dega).
  }) = _UniverseChapterDetailDto;

  factory UniverseChapterDetailDto.fromJson(Map<String, dynamic> json) =>
      _$UniverseChapterDetailDtoFromJson(json);

  UniverseChapter toDomain() => UniverseChapter(
    id: id,
    title: title,
    description: description,
    order: order,
    video: video?.toDomain(),
    mcqs: mcqs.map((q) => q.toDomain()).toList(),
  );
}

// ── MCQ question (chapter-scoped) ───────────────────────────────────────────────
@freezed
abstract class UniverseMcqDto with _$UniverseMcqDto {
  const UniverseMcqDto._();

  const factory UniverseMcqDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'question') required String question,
    @JsonKey(name: 'chapterId') int? chapterId,
    @JsonKey(name: 'options') @Default([]) List<UniverseMcqOptionDto> options,
  }) = _UniverseMcqDto;

  factory UniverseMcqDto.fromJson(Map<String, dynamic> json) =>
      _$UniverseMcqDtoFromJson(json);

  /// Reuses the same generic McqQuestion domain model as FinancialLiteracy.
  McqQuestion toDomain() => McqQuestion(
    id: id,
    question: question,
    options: options.map((o) => o.toDomain()).toList(),
  );
}

// ── MCQ option ────────────────────────────────────────────────────────────────
@freezed
abstract class UniverseMcqOptionDto with _$UniverseMcqOptionDto {
  const UniverseMcqOptionDto._();

  const factory UniverseMcqOptionDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'text') required String text,
    @JsonKey(name: 'mcqId') int? mcqId,
    @JsonKey(name: 'isCorrect') @Default(false) bool isCorrect,
  }) = _UniverseMcqOptionDto;

  factory UniverseMcqOptionDto.fromJson(Map<String, dynamic> json) =>
      _$UniverseMcqOptionDtoFromJson(json);

  McqOption toDomain() => McqOption(
    id: id,
    text: text,
    isCorrect: isCorrect,
  );
}
