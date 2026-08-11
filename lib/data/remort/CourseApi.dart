
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../dto/course/get_course/GetCourseResponse.dart';
import '../dto/course/get_progress/GetProgressResponse.dart';
import '../dto/course/get_single_course/GetSingleCourseResponse.dart';
import '../dto/course/get_topic/GetTopicResponse.dart';

// import '../dto/get_course_response.dart';
// import '../dto/get_single_course_response.dart';
// import '../dto/get_topic_response.dart';
// import '../dto/get_progress_response.dart';

part 'CourseApi.g.dart';

@RestApi()
abstract class CourseApi {
  factory CourseApi(Dio dio, {String baseUrl}) = _CourseApi;

  // 1. Get All Courses — CoursesScreen
  @GET('/courses')
  Future<List<GetCourseResponse>> getAllCourses();

  // 2. Get Single Course with lectures — CourseDetailScreen
  @GET('/courses/{courseId}')
  Future<GetSingleCourseResponse> getCourse(
      @Path('courseId') int courseId,
      );

  // 3. Get Particular Lecture — CoursePlayerScreen
  @GET('/courses/{courseId}/lecture/{lectureId}')
  Future<GetTopicResponse> getLecture(
      @Path('courseId') int courseId,
      @Path('lectureId') int lectureId,
      );

  // 4. Course Progress — CoursePlayerScreen
  @GET('/courses/{courseId}/progress')
  Future<GetProgressResponse> getProgress(
      @Path('courseId') int courseId,
      );
}