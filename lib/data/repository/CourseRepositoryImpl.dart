
import 'package:dio/dio.dart';

import '../../domain/model/course/CourseModel.dart';
import '../../domain/model/course/CourseProgressModel.dart';
import '../../domain/model/course/LectureModel.dart';
import '../../domain/repository/CourseRepository.dart';
//import '../../utils/NetworkResult.dart';
import '../../../utils/NetworkResultForCourse.dart';
import '../remort/CourseApi.dart';

// import '../../domain/course_domain.dart';
// import '../dto/get_course_response.dart';
// import '../dto/get_single_course_response.dart';
// import '../dto/get_topic_response.dart';
// import '../dto/get_progress_response.dart';
// import 'course_api.dart';


// ══════════════════════════════════════════════════════════════
//  IMPLEMENTATION
// ══════════════════════════════════════════════════════════════
class CourseRepositoryImpl implements CourseRepository {
  final CourseApi _courseApi;
  CourseRepositoryImpl(this._courseApi);

  @override
  Future<NetworkResult<List<CourseModel>>> getAllCourses() async {
    try {
      final response = await _courseApi.getAllCourses();
      return NetworkResult.success(response.map((c) => c.toDomain()).toList());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<NetworkResult<CourseModel>> getCourse(int courseId) async {
    try {
      final response = await _courseApi.getCourse(courseId);
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<NetworkResult<LectureModel>> getLecture(
      int courseId, int lectureId) async {
    try {
      final response = await _courseApi.getLecture(courseId, lectureId);
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<NetworkResult<CourseProgressModel>> getProgress(int courseId) async {
    try {
      final response = await _courseApi.getProgress(courseId);
      return NetworkResult.success(response.toDomain());
    } on DioException catch (e) {
      return NetworkResult.error(
        message: _parseDioError(e),
        statusCode: e.response?.statusCode,
      );
    } catch (e) {
      return NetworkResult.error(message: 'Unexpected error: $e');
    }
  }

  String _parseDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          return data['message'].toString();
        }
        return 'Server error (${e.response?.statusCode})';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}