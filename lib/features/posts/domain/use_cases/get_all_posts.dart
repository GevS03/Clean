// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:clean_architecture/features/posts/domain/repositories/post_repositoriy.dart';
import 'package:dartz/dartz.dart';

class GetAllPostsUseCase {
  final PostRepository repository;
  GetAllPostsUseCase({
    required this.repository,
  });

  Future<Either<Failure, List<Post>>> call() async {
    return await repository.getAllPosts();
  }
}
