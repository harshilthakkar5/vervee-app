
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../domain/model/VerveeUniverse/ChapterVideo.dart';
import '../../../domain/model/VerveeUniverse/UniverseChapter.dart';
import '../../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';

//import '../../../domain/model/VerveeUniverse/ChapterVideo.dart';
//import '../../../domain/model/VerveeUniverse/UniverseChapter.dart';
//import '../../../domain/model/VerveeUniverse/VerveeUniverseItem.dart';

part 'VerveeUniverseItemResponse.freezed.dart';
part 'VerveeUniverseItemResponse.g.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  DTOs — GET /vervee-universe  (list)
// ═══════════════════════════════════════════════════════════════════════════════

List<VerveeUniverseItemDto> verveeUniverseListFromJson(List<dynamic> json) =>
    json
        .map((x) => VerveeUniverseItemDto.fromJson(x as Map<String, dynamic>))
        .toList();

// ── Universe item (list response) ─────────────────────────────────────────────
@freezed
abstract class VerveeUniverseItemDto with _$VerveeUniverseItemDto {
  const VerveeUniverseItemDto._();

  const factory VerveeUniverseItemDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'verveeUniverseTitle') required String verveeUniverseTitle,
    @JsonKey(name: 'verveeUniverseSubtitle')
    @Default('') String verveeUniverseSubtitle,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'thumbnail') String? thumbnail,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'likesCount') @Default(0) int likesCount,

    // ✅ FIX — list response me kabhi-kabhi ye fields missing ho sakte he
    //          (jaise detail response me), isliye default rakha he
    @JsonKey(name: 'isLiked') @Default(false) bool isLiked,
    @JsonKey(name: 'isOwner') @Default(false) bool isOwner,
    @JsonKey(name: 'userName') String? userName,

    @JsonKey(name: 'chapters')
    @Default([]) List<UniverseChapterDto> chapters,
  }) = _VerveeUniverseItemDto;

  factory VerveeUniverseItemDto.fromJson(Map<String, dynamic> json) =>
      _$VerveeUniverseItemDtoFromJson(json);

  /// DTO → Domain
  VerveeUniverseItem toDomain() => VerveeUniverseItem(
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

// ── Chapter inside a universe item ─────────────────────────────────────────────
@freezed
abstract class UniverseChapterDto with _$UniverseChapterDto {
  const UniverseChapterDto._();

  const factory UniverseChapterDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'description') @Default('') String description,
    @JsonKey(name: 'order') @Default(1) int order,
    @JsonKey(name: 'verveeUniverseId') int? verveeUniverseId,
    @JsonKey(name: 'video') UniverseVideoDto? video,
  }) = _UniverseChapterDto;

  factory UniverseChapterDto.fromJson(Map<String, dynamic> json) =>
      _$UniverseChapterDtoFromJson(json);

  UniverseChapter toDomain() => UniverseChapter(
    id: id,
    title: title,
    description: description,
    order: order,
    video: video?.toDomain(),
  );
}

// ── Video inside a chapter ──────────────────────────────────────────────────────
@freezed
abstract class UniverseVideoDto with _$UniverseVideoDto {
  const UniverseVideoDto._();

  const factory UniverseVideoDto({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'title') required String title,
    @JsonKey(name: 'content') @Default('') String content,
    @JsonKey(name: 'contentUpload') String? contentUpload,
    @JsonKey(name: 'duration') int? duration,
    @JsonKey(name: 'chapterId') int? chapterId,
  }) = _UniverseVideoDto;

  factory UniverseVideoDto.fromJson(Map<String, dynamic> json) =>
      _$UniverseVideoDtoFromJson(json);

  ChapterVideo toDomain() => ChapterVideo(
    id: id,
    title: title,
    content: content,
    videoUrl: contentUpload,
    duration: duration,
  );
}
