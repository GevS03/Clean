// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:clean_architecture/core/error/exeption.dart';
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_architecture/features/posts/data/models/post_model.dart';

abstract class PostLocalDataSource {
  Future<List<PostModel>> getCachedPosts();
  Future<Unit> cachePosts(List<PostModel> postmodel);
}

const cachedPosts = 'CACHED_POSTS';

class PostLocalDataSourceImpl implements PostLocalDataSource {
  final SharedPreferences sharedPreferences;
  PostLocalDataSourceImpl({
    required this.sharedPreferences,
  });
  @override
  Future<Unit> cachePosts(List<PostModel> postModel) {
    List postModelsToJson = postModel
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    sharedPreferences.setString(cachedPosts, jsonEncode(postModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostModel>> getCachedPosts() {
    final jsonString = sharedPreferences.getString(cachedPosts);
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<PostModel> jsonToPostModels = decodeJsonData
          .map<PostModel>((jsonPostModel) => PostModel.fromJson(jsonPostModel))
          .toList();
      return Future.value(jsonToPostModels);
    } else {
      throw EmptyCacheExeption();
    }
  }
}
