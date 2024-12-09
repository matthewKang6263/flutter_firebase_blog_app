import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends StateNotifier<List<Post>> {
  HomeViewModel(this._postRepository) : super([]) {
    _loadPosts();
  }

  final PostRepository _postRepository;

  // Firestore에서 게시물 스트림 구독 및 상태 업데이트
  void _loadPosts() {
    _postRepository.postListStream().listen(
      (posts) {
        state = posts; // 게시물 상태 업데이트
      },
      onError: (error) {
        print('Error loading posts: $error'); // 오류 로그
        state = []; // 상태 초기화
      },
    );
  }
}

// 의존성 주입을 위한 Provider 정의
final postRepositoryProvider = Provider((ref) => PostRepository());

final homeViewModelProvider =
    StateNotifierProvider<HomeViewModel, List<Post>>((ref) {
  final postRepository = ref.watch(postRepositoryProvider);
  return HomeViewModel(postRepository);
});
