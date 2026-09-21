
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/remort/ReelApi.dart';
import '../data/repository/ReelRepositoryImpl.dart';
import '../domain/repository/ReelRepository.dart';
import 'AuthModule.dart'; // ✅ existing dioProvider yahin se aata he

part 'ReelModule.g.dart';

@riverpod
ReelApi reelApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ReelApi(dio);
}

@riverpod
ReelRepository reelRepository(Ref ref) {
  return ReelRepositoryImpl(ref.watch(reelApiProvider));
}