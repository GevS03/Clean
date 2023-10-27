// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:clean_architecture/core/error/exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import 'package:clean_architecture/features/posts/data/models/post_model.dart';
import 'package:clean_architecture/features/posts/domain/entities/post_entity.dart';

abstract class PostRemoteDataSource {
  Future<List<PostModel>> getAllPosts();
  Future<Unit> deletePost(int postId);
  Future<Unit> updatePost(PostModel post);
  Future<Unit> addPost(PostModel post);
}

const baseUrl = 'https://jsonplaceholder.typicode.com';

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;
  PostRemoteDataSourceImpl({
    required this.client,
  });
  @override
  Future<List<PostModel>> getAllPosts() async {
    final response = await client.get(Uri.parse(baseUrl + '/posts/'), headers: {
      'Content - Type': 'aplication/json',
    });

    if (response.statusCode == 200) {
      final List decodeJson = jsonDecode(response.body) as List;
      final List<PostModel> postModels = decodeJson
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return postModels;
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> addPost(PostModel postModel) async {
    final body = {
      'title': postModel.title,
      'body': postModel.body,
    };

    final response =
        await client.post(Uri.parse(baseUrl + '/posts/'), body: body);

    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> deletePost(int postId) async {
    final response = await client
        .delete(Uri.parse(baseUrl + '/posts/${postId.toString()}'), headers: {
      'Content - Type': 'aplication/json',
    });

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerExeption();
    }
  }

  @override
  Future<Unit> updatePost(Post postModel) async {
    final postId = postModel.id.toString();
    final body = {'title': postModel.title, 'body': postModel.body};

    final response =
        await client.patch(Uri.parse(baseUrl + '/posts/$postId'), body: body);

    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerExeption();
    }
  }
}
