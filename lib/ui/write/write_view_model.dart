import 'dart:io';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

// 글 작성 상태를 나타내는 클래스
class WriteState {
  final bool isWriting;
  final String? imageUrl;

  WriteState({
    required this.isWriting,
    this.imageUrl,
  });

  // 상태 복사 메서드
  WriteState copyWith({
    bool? isWriting,
    String? imageUrl,
  }) {
    return WriteState(
      isWriting: isWriting ?? this.isWriting,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

// 글 작성 뷰모델
class WriteViewModel extends StateNotifier<WriteState> {
  WriteViewModel(Post? post)
      : super(WriteState(isWriting: false, imageUrl: post?.imageUrl));

  final PostRepository _postRepository = PostRepository();

  // 글 작성 또는 수정 메서드
  Future<bool> insert({
    required String writer,
    required String title,
    required String content,
  }) async {
    if (state.imageUrl == null) return false;

    state = state.copyWith(isWriting: true);

    try {
      final result = await _postRepository.insert(
        title: title,
        content: content,
        writer: writer,
        imageUrl: state.imageUrl!,
      );
      state = state.copyWith(isWriting: false);
      return result;
    } catch (e) {
      print('Error inserting post: $e');
      state = state.copyWith(isWriting: false);
      return false;
    }
  }

  // 이미지 업로드 메서드
  Future<void> uploadImage(XFile xFile) async {
    try {
      final storage = FirebaseStorage.instance;
      Reference ref = storage.ref();
      Reference fileRef =
          ref.child('${DateTime.now().microsecondsSinceEpoch}_${xFile.name}');
      await fileRef.putFile(File(xFile.path));
      String imageUrl = await fileRef.getDownloadURL();
      state = state.copyWith(imageUrl: imageUrl);
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}

// WriteViewModel 프로바이더
final writeViewModelProvider =
    StateNotifierProvider.family<WriteViewModel, WriteState, Post?>(
        (ref, post) {
  return WriteViewModel(post);
});
