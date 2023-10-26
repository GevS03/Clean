// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:clean_architecture/features/posts/domain/repositories/post_repositoriy.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class AddPostUseCase {
  PostRepository repository;
  AddPostUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call(Post post) {
    return repository.addPost(post);
  }
}
