import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'AuthModule.dart'; // dioProvider yahi se aayega
import '../data/remort/AffiliateApi.dart';
import '../data/repository/AffiliateRepositoryImpl.dart';
import '../domain/repository/AffiliateRepository.dart';

part 'AffiliateModule.g.dart';

@riverpod
AffiliateApi affiliateApi(Ref ref) {
  final dio = ref.watch(dioProvider); // ✅ same authenticated dio, token auto-attach
  return AffiliateApi(dio);
}

@riverpod
AffiliateRepository affiliateRepository(Ref ref) {
  final api = ref.watch(affiliateApiProvider);
  return AffiliateRepositoryImpl(api);
}