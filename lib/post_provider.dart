import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'post.dart';

class PostProvider extends ChangeNotifier {
  List<Post> _posts = [];
  List<Post> get posts => _posts;

  Future<void> loadAllPosts() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? allPostsJson = prefs.getStringList('all_posts');

      if (allPostsJson != null) {
        _posts = allPostsJson.map((postJson) {
          try {
            return Post.fromJson(jsonDecode(postJson));
          } catch (e) {
            print('Failed to decode JSON string: $postJson');
            return null;
          }
        }).whereType<Post>().toList();
        notifyListeners();
      }
    } catch (e) {
      print('Failed to load posts: $e');
    }
  }

  Future<void> loadPosts(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? postsJson = prefs.getStringList('${username}_posts');

    if (postsJson != null) {
      _posts = postsJson
          .map((postJson) => Post.fromJson(jsonDecode(postJson)))
          .toList();
      notifyListeners();
    }
  }


  Future<void> savePost(String username, Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String postJson = jsonEncode(post.toJson());

    List<String> postsJson = prefs.getStringList('${username}_posts') ?? [];
    postsJson.add(postJson);
    await prefs.setStringList('${username}_posts', postsJson);

    _posts.add(post);
    notifyListeners();
  }

  Future<void> clearPosts(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('${username}_posts');
    _posts.clear();
    notifyListeners();
  }

  List<Post> getPostsByUsername(String username) {
    return _posts.where((post) => post.username == username).toList();
  }

  Future<void> likePost(Post post) async {
    post.likes++;
    await _updatePost(post);
    notifyListeners();
  }

  Future<void> dislikePost(Post post) async {
    post.dislikes++;
    await _updatePost(post);
    notifyListeners();
  }

  Future<void> _updatePost(Post post) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> postsJson = prefs.getStringList('${post.username}_posts') ?? [];

    int index = postsJson.indexWhere((postJson) {
      final p = Post.fromJson(jsonDecode(postJson));
      return p.caption == post.caption && p.timestamp == post.timestamp;
    });

    if (index != -1) {
      postsJson[index] = jsonEncode(post.toJson());
      await prefs.setStringList('${post.username}_posts', postsJson);
    }
  }
}