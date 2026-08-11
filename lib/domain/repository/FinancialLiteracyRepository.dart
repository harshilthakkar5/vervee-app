
import '../../utils/NetworkResult.dart';
import '../model/FinancialLiteracy/FinancialLiteracyCourse.dart';
import '../model/FinancialLiteracy/FinancialLiteracyDetail.dart';

// ═══════════════════════════════════════════════════════════════════════════════
//  ABSTRACT REPOSITORY
// ═══════════════════════════════════════════════════════════════════════════════

abstract interface class FinancialLiteracyRepository {

  /// All courses list
  Future<NetworkResult<List<FinancialLiteracyCourse>>> getCourses();

  /// Single course detail + MCQs
  Future<NetworkResult<FinancialLiteracyDetail>> getCourseDetail(int id);
}
