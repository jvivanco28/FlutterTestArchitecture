import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_bloc/data/rest/exceptions/api_exceptions.dart';
import 'package:test_bloc/data/rest/models/error_model.dart';
import 'package:test_bloc/data/rest/models/post_model.dart';

class PostsRepository {

  Future<Post> fetchPost(int id) async {

    debugPrint("fetching post $id");

    final response = await http.get('https://jsonplaceholder.typicode.com/posts/$id');
//    final response = await http.get('https://jsonplaceholder.typicode.com/postsss/$id');
//    final response = await http.get('https://bogus_api/$id');

    final responseJson = json.decode(response.body);

    debugPrint("statusCode = ${response.statusCode}");
    debugPrint("body = ${response.body}");

    if ( response.statusCode != HttpStatus.OK ) {
      throw RestApiException(ErrorModel.fromJson(responseJson));
    }
    return new Post.fromJson(responseJson);
  }

//  Future<List<Post>> fetchPosts() async {
//
//    debugPrint("fetching posts");
//
//    final response = await http.get('https://jsonplaceholder.typicode.com/posts');
//    final responseJson = json.decode(response.body);
//
//    if ( response.statusCode != HttpStatus.OK ) {
//      throw RestApiException(ErrorModel.fromJson(responseJson));
//    }
//  }
}