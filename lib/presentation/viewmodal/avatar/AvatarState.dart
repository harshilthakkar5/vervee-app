
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../../../domain/models/avatar/AvatarDomain.dart';
// import '../../modules/AvatarModule.dart';
import '../../../domain/model/avatar/AvatarUserInfo.dart';
import '../../../utils/AuthService.dart'; // apna existing AuthService

part 'AvatarState.freezed.dart';
//part 'AvatarState.g.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  STATE
// ══════════════════════════════════════════════════════════════════════════════

@freezed
sealed class AvatarState with _$AvatarState {
  const factory AvatarState({

    // ── User info (GET pe aata hai) ─────────────────────────────────────────
    AvatarUserInfo? userInfo,

    // ── Current generated mascot URL (POST ke baad aata hai) ───────────────
    String? generatedMascotUrl,
    String? generatedMascotId,

    // ── Loading states ──────────────────────────────────────────────────────
    @Default(false) bool isLoadingInfo,       // GET user-info
    @Default(false) bool isSelectingMascot,   // POST select-mascot
    @Default(false) bool isGenerating,        // POST customize (Generate btn)

    // ── Success flags ───────────────────────────────────────────────────────
    @Default(false) bool mascotSaved,         // select-mascot success
    @Default(false) bool customizeSuccess,    // customize success

    // ── Error ───────────────────────────────────────────────────────────────
    String? errorMessage,

  }) = _AvatarState;
}