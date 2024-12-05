import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeViewModel extends Notifier<List<Post>> {
  @override
  List<Post> build() {
    getAllPosts();
    return [];
  }

  void getAllPosts() async {
    final postRepo = PostRepository();
    final stream = postRepo.postListStream();
    final streamSubscription = stream.listen((posts) {
      state = posts;
    });

    ref.onDispose(() {
      streamSubscription.cancel();
    });
  }
}

final homeViewModelProvider = NotifierProvider<HomeViewModel, List<Post>>(() {
  return HomeViewModel();
});
