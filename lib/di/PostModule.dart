
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:vervee_app/domain/repository/PostRepository.dart';
import '../data/remort/PostApi.dart';
//import '../data/remote/post_api.dart';
import '../data/repository/PostRepositoryImpl.dart';
//import '../data/repository/post_repository_impl.dart';
//import '../domain/repository/post_repository.dart';
import 'AuthModule.dart';
//import 'auth_module.dart'; // dioProvider yahan se

part 'PostModule.g.dart';

@riverpod
PostApi postApi(Ref ref) {
  final dio = ref.watch(dioProvider);
  return PostApi(dio);
}

@riverpod
PostRepository postRepository(Ref ref) {
  return PostRepositoryImpl(ref.watch(postApiProvider));
}





































