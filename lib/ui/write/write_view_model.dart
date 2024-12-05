import 'dart:io';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WriteState {
  final bool isWriting;
  final String? imageUrl;

  WriteState({
    required this.isWriting,
    this.imageUrl,
  });

  WriteState copyWith({
    required bool isWriting,
    String? imageUrl,
  }) {
    return WriteState(
        isWriting: isWriting ?? this.isWriting,
        imageUrl: imageUrl ?? this.imageUrl);
  }
}

class WriteViewModel extends StateNotifier<WriteState> {
  WriteViewModel(Post? post)
      : super(WriteState(isWriting: false, imageUrl: null));

  final PostRepository _postRepository = PostRepository();

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
          imageUrl: state.imageUrl!);
      state = state.copyWith(isWriting: false);
      return result;
    } catch (e) {
      print('Error inserting post:$e');
      state = state.copyWith(isWriting: false);
      return false;
    }
  }

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
      print('Error uploading image:$e');
    }
  }
}

final writeViewModelProvider =
    StateNotifierProvider.family<WriteViewModel, WriteState, Post?>(
        (ref, post) {
  return WriteViewModel(post);
});
