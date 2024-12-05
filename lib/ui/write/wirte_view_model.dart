import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WriteState {
  bool isWriting;
  WriteState(this.isWriting);
}

class WirteViewModel extends AutoDisposeFamilyNotifier<WriteState, Post?> {
  @override
  WriteState build(Post? arg) {
    return WriteState(false);
  }

  Future<bool> insert({
    required String writer,
    required String title,
    required String content,
  }) async {
    final postRepository = PostRepository();

    state = WriteState(true);
    if (arg == null) {
      final result = await postRepository.insert(
          title: title,
          content: content,
          writer: writer,
          imageUrl: 'https://picsum.photos/200/300');
      state = WriteState(false);
      await Future.delayed(Duration(milliseconds: 500));
      return result;
    } else {
      final result = await postRepository.update(
          id: arg!.id,
          title: title,
          content: content,
          writer: writer,
          imageUrl: 'https://picsum.photos/200/300');
      state = WriteState(false);
      await Future.delayed(Duration(milliseconds: 500));
      return result;
    }
  }
}

final writeViewModelProvider =
    NotifierProvider.autoDispose.family<WirteViewModel, WriteState, Post?>(() {
  return WirteViewModel();
});
