
// ══════════════════════════════════════════════════════════════
//  ABSTRACT REPOSITORY
// ══════════════════════════════════════════════════════════════
//import '../../utils/NetworkResult.dart';
import '../../../utils/NetworkResultForCourse.dart';
import '../model/course/CourseModel.dart';
import '../model/course/CourseProgressModel.dart';
import '../model/course/LectureModel.dart';

abstract interface class CourseRepository {

  Future<NetworkResult<List<CourseModel>>> getAllCourses();

  Future<NetworkResult<CourseModel>> getCourse(int courseId);

  Future<NetworkResult<LectureModel>> getLecture(int courseId, int lectureId);

  Future<NetworkResult<CourseProgressModel>> getProgress(int courseId);
}