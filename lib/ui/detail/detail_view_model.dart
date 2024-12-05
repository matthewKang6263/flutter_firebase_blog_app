import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DetailViewModel extends AutoDisposeFamilyNotifier<Post, Post> {
  @override
  Post build(Post arg) {
    listenStream();
    return arg;
  }

  final postRepository = PostRepository();

  // 게시물 삭제 기능
  Future<bool> deletePost() async {
    return await postRepository.delete(arg.id);
  }

  // 게시물 스트림 리스닝
  void listenStream() {
    final stream = postRepository.postStream(arg.id);
    final streamSub = stream.listen((data) {
      if (data != null) {
        state = data;
      }
    });
    ref.onDispose(() {
      streamSub.cancel();
    });
  }
}

final detailViewModelProvider =
    NotifierProvider.autoDispose.family<DetailViewModel, Post, Post>(() {
  return DetailViewModel();
});
