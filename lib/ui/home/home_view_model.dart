import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends StateNotifier<List<Post>> {
  HomeViewModel(this._postRepository) : super([]) {
    _loadPosts();
  }

  final PostRepository _postRepository;

  // 게시물 로드
  void _loadPosts() {
    _postRepository.postListStream().listen(
      (posts) {
        state = posts;
      },
      onError: (error) {
        print('Error loading posts: $error');
        state = [];
      },
    );
  }
}

final postRepositoryProvider = Provider((ref) => PostRepository());

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<Post>>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return HomeViewModel(postRepository);
});
