import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/remort/CourseApi.dart';
import '../data/repository/CourseRepositoryImpl.dart';
import '../domain/repository/CourseRepository.dart';
import 'AuthModule.dart'; // ya jahan bhi tera dioProvider hai

part 'CourseModule.g.dart';

// ═══════════════════════════════════════════════════════════════
//  DI PROVIDERS
// ═══════════════════════════════════════════════════════════════

@riverpod
CourseApi courseApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return CourseApi(dio);
}

@riverpod
CourseRepository courseRepository(Ref ref) {
  return CourseRepositoryImpl(ref.watch(courseApiProvider));
}

