
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../di/AffiliateModule.dart';
//import '../../../domain/model/affiliate/AffiliateInfo.dart';
import '../../../domain/model/promo_code/AffiliateInfo.dart';
import '../../../utils/NetworkResult.dart';

part 'AffiliateViewModel.g.dart';

@riverpod
class AffiliateViewModel extends _$AffiliateViewModel {
  @override
  NetworkResult<AffiliateInfo> build() => const NetworkResult.initial();

  // Screen open pe: full loader. Pull-to-refresh pe: silent = true
  // (purana data screen pe rehta he, loader nahi flash hota)
  Future<void> fetchAffiliate({bool silent = false}) async {
    if (!silent) {
      state = const NetworkResult.loading();
    }

    final result = await ref.read(affiliateRepositoryProvider).getMyAffiliate();
    state = result;
  }
}