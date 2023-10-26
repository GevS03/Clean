// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_architecture/features/posts/domain/repositories/post_repositoriy.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';

class DeletePostUseCase {
  PostRepository repository;
  DeletePostUseCase({
    required this.repository,
  });

  Future<Either<Failure, Unit>> call(int postId) {
    return repository.deletePost(postId);
  }
}
