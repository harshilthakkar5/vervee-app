
import '../../utils/NetworkResult.dart';
import '../model/VerveeUniverse/VerveeUniverseDetail.dart';
import '../model/VerveeUniverse/VerveeUniverseItem.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  ABSTRACT REPOSITORY
// ═══════════════════════════════════════════════════════════════════════════════

abstract interface class VerveeUniverseRepository {
  /// GET /vervee-universe — saare universe items (list)
  Future<NetworkResult<List<VerveeUniverseItem>>> getUniverseItems();

  /// GET /vervee-universe/{id} — single item detail + per-chapter MCQs
  Future<NetworkResult<VerveeUniverseDetail>> getUniverseItemDetail(int id);
}
