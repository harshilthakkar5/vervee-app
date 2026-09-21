
import '../../utils/NetworkResult.dart';
import '../model/post/ReelPost.dart';
//import '../model/reel/ReelPost.dart';

abstract interface class ReelRepository {
  Future<NetworkResult<List<ReelPost>>> getReels({
    required int page,
    required int limit,
    int? initialPostId,
  });
}