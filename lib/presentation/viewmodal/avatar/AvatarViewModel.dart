
import 'dart:io';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
// import '../../../domain/models/avatar/AvatarDomain.dart';
// import '../../modules/AvatarModule.dart';
import '../../../di/AvatarModule.dart';
import '../../../utils/AuthService.dart';
import '../../../utils/NetworkResult.dart';
import 'AvatarState.dart'; // apna existing AuthService

//part 'AvatarViewModel.freezed.dart';
part 'AvatarViewModel.g.dart';

// ══════════════════════════════════════════════════════════════════════════════
//  VIEWMODEL
// ══════════════════════════════════════════════════════════════════════════════

@riverpod
class AvatarViewModel extends _$AvatarViewModel {

  @override
  AvatarState build() {
    // Screen open hote hi user info load karo
    Future.microtask(() => loadUserInfo());
    return const AvatarState();
  }

  // ── Helper: userId from AuthService ────────────────────────────────────────
  // int get _userId => AuthService.instance.getUserId() ?? 0;
  Future<int> get _userId async {return (await AuthService.instance.getUserId()) ?? 0;}

  // ── Mascot index → mascotId mapping ────────────────────────────────────────
  // Backend pe mascotId strings hain (e.g. "21", "22" ...)
  // Apni _avatarImages list ke index ke hisaab se map karo
  static const List<String> _mascotIds = [
    '21', // MaxBull    → index 0
    '22', // Grizz      → index 1
    '24', // Falcor   → index 2
    '25', // Hugo     → index 3
    '26', // BlazeFox  → index 4
    '27', // RockyShell→ index 5
  ];

  // Gear label → backend key mapping
  static const Map<String, String> _gearKeyMap = {
    'Shirt':     'shirt',
    'Headwear':  'cap',
    'Watch':     'watch',
    'Accessory': 'chain',
    'Footwear':  'shoes',
    'Audio':     'headphone',
    'Eyewear':   'sunglasses',
    'Backpack':  'backpack',
    'Gear':      'skateboard',
  };

  // ── 1. GET /avatar/user-info ───────────────────────────────────────────────
  Future<void> loadUserInfo() async {
    if (state.isLoadingInfo) return;

    state = state.copyWith(isLoadingInfo: true, errorMessage: null);

    final result = await ref
        .read(avatarRepositoryProvider)
        .getUserInfo(userId: await _userId);

   // if (!ref.mounted) return;

    result.when(
      initial: () {},
      loading: () {},
      success: (info) {
        state = state.copyWith(
          userInfo: info,
          isLoadingInfo: false,
          // Agar pehle se mascot saved hai to URL set karo
          generatedMascotUrl: info.mascotUrl,
          generatedMascotId:  info.mascotId,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isLoadingInfo: false,
          errorMessage: message,
        );
      },
    );
  }

  // ── 2. POST /avatar/select-mascot ─────────────────────────────────────────
  // avatarIndex = current selected avatar index (0–5)
  // avatarFile  = local asset ko File mein convert karke pass karo
  Future<void> selectMascot({
    required int  avatarIndex,
    required File avatarFile,
  }) async {
    if (state.isSelectingMascot) return;

    state = state.copyWith(
      isSelectingMascot: true,
      errorMessage: null,
      mascotSaved: false,
    );

    final mascotId = _mascotIds[avatarIndex];

    final result = await ref
        .read(avatarRepositoryProvider)
        .selectMascot(
      userId:     await _userId,
      mascotId:   mascotId,
      avatarFile: avatarFile,
    );

   // if (!ref.mounted) return;

    result.when(
      initial: () {},
      loading: () {},
      success: (avatarResult) {
        state = state.copyWith(
          isSelectingMascot:  false,
          mascotSaved:        true,
          generatedMascotUrl: avatarResult.mascotUrl,
          generatedMascotId:  avatarResult.mascotId,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isSelectingMascot: false,
          errorMessage: message,
        );
      },
    );
  }

  // ── 3. POST /avatar/customize  (Generate New Look button) ─────────────────
  // equippedLabels = ['Shirt', 'Watch', ...] — equipped gear ke labels
  // customPrompt   = text field ki value
  Future<void> generateLook({
    required List<String> equippedLabels,
    required String       customPrompt,
  }) async {
    if (state.isGenerating) return;

    state = state.copyWith(
      isGenerating: true,
      errorMessage: null,
      customizeSuccess: false,
    );

    // Label → backend key convert karo
    final selectedItems = equippedLabels
        .map((label) => _gearKeyMap[label] ?? label.toLowerCase())
        .toList();

    final result = await ref
        .read(avatarRepositoryProvider)
        .customizeAvatar(
      userId:        await _userId,
      selectedItems: selectedItems,
      customPrompt:  customPrompt,
    );

   // if (!ref.mounted) return;

    result.when(
      initial: () {},
      loading: () {},
      success: (avatarResult) {
        state = state.copyWith(
          isGenerating:       false,
          customizeSuccess:   true,
          generatedMascotUrl: avatarResult.mascotUrl,
          generatedMascotId:  avatarResult.mascotId,
        );
      },
      error: (message, _) {
        state = state.copyWith(
          isGenerating: false,
          errorMessage: message,
        );
      },
    );
  }

  // ── Reset ──────────────────────────────────────────────────────────────────
  void clearError() => state = state.copyWith(errorMessage: null);
  void resetSuccessFlags() => state = state.copyWith(
    mascotSaved: false,
    customizeSuccess: false,
  );
}