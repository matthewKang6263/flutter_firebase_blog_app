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

  Future<bool> deletePost() async {
    final postRepository = PostRepository();
    return await postRepository.delete(arg.id);
  }

  void listenStream() {
    final stream = PostRepository().postStream(arg.id);
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
