
// ─────────────────────────────────────────────────────────────────────────────
//  FILE: presentation/modules/AvatarModule.dart
// ─────────────────────────────────────────────────────────────────────────────

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/remort/AvatarApi.dart';
import '../data/repository/AvatarRepositoryImpl.dart';
import '../domain/repository/AvatarRepository.dart';
import 'AuthModule.dart';
// import '../../data/api/AvatarApi.dart';
// import '../../data/repository/AvatarRepositoryImpl.dart';
// import '../../domain/repository/AvatarRepository.dart';
// import '../di/DioModule.dart'; // apna existing dioProvider

part 'AvatarModule.g.dart';

@riverpod
AvatarApi avatarApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return AvatarApi(dio);
}

@riverpod
AvatarRepository avatarRepository(Ref ref) {
  return AvatarRepositoryImpl(ref.watch(avatarApiProvider));
}