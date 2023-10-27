// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:clean_architecture/core/error/exeption.dart';
import 'package:clean_architecture/core/network/network_info.dart';
import 'package:clean_architecture/features/posts/data/models/post_model.dart';
import 'package:dartz/dartz.dart';

import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/features/posts/data/datasources/post_local_data_source.dart';
import 'package:clean_architecture/features/posts/data/datasources/post_remote_data_source.dart';
import 'package:clean_architecture/features/posts/domain/entities/post_entity.dart';
import 'package:clean_architecture/features/posts/domain/repositories/post_repositoriy.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheExeption {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    return await _getMessige(() {
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {
    return await _getMessige(() {
      return remoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);

    return await _getMessige(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessige(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerExeption {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
