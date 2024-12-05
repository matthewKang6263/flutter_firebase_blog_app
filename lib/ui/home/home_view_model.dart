import 'dart:async';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends StateNotifier<List<Post>> {
  HomeViewModel() : super([]) {
    getAllPosts();
  }

  final PostRepository _postRepository = PostRepository();

  Future<void> getAllPosts() async {
    try {
      final stream = _postRepository.postListStream();
      await for (final posts in stream) {
        state = posts;
      }
    } catch (e) {
      print('Error fetching posts: $e');
      state = [];
    }
  }
}

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<Post>>((ref) {
  return HomeViewModel();
});
