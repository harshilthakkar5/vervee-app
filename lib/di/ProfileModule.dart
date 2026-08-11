
import 'package:riverpod_annotation/riverpod_annotation.dart';
//import '../data/api/profile_api.dart';
import '../data/remort/ProfileApi.dart';
import '../data/repository/ProfileRepositoryImpl.dart';
//import '../data/repository/profile_repository_impl.dart';
import '../domain/repository/ProfileRepository.dart';
//import '../domain/repository/profile_repository.dart';
import 'AuthModule.dart';
// apka existing dioProvider yahan se import karo:
// import '../core/dio_provider.dart';

part 'ProfileModule.g.dart';

// ── ProfileApi provider ────────────────────────────────────────────
@riverpod
ProfileApi profileApi(Ref ref) {
  final dio = ref.watch(dioProvider); // apka existing dioProvider
  return ProfileApi(dio);
}

// ── ProfileRepository provider ─────────────────────────────────────
@riverpod
ProfileRepository profileRepository(Ref ref) {
  return ProfileRepositoryImpl(ref.watch(profileApiProvider));
}


