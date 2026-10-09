
// domain/repository/AffiliateRepository.dart
import '../model/promo_code/AffiliateInfo.dart';
import '../../utils/NetworkResult.dart';
//import '../../data/model/affiliate/AffiliateInfo.dart';

abstract interface class AffiliateRepository {
  Future<NetworkResult<AffiliateInfo>> getMyAffiliate();
}