import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';
import 'package:flutter_firebase_blog_app/data/repository/post_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class WriteState {
  bool isWriting;
  String? imageUrl;
  WriteState(this.isWriting, this.imageUrl);
}

class WriteViewModel extends AutoDisposeFamilyNotifier<WriteState, Post?> {
  @override
  WriteState build(Post? arg) {
    return WriteState(false, arg?.imageUrl);
  }

  Future<bool> insert({
    required String writer,
    required String title,
    required String content,
  }) async {
    if (state.imageUrl == null) {
      return false;
    }
    final postRepository = PostRepository();

    state = WriteState(true, state.imageUrl);
    if (arg == null) {
      final result = await postRepository.insert(
          title: title,
          content: content,
          writer: writer,
          imageUrl: state.imageUrl!);
      state = WriteState(false, state.imageUrl);
      await Future.delayed(const Duration(milliseconds: 500));
      return result;
    } else {
      final result = await postRepository.update(
          id: arg!.id,
          title: title,
          content: content,
          writer: writer,
          imageUrl: state.imageUrl!);
      state = WriteState(false, state.imageUrl);
      await Future.delayed(const Duration(milliseconds: 500));
      return result;
    }
  }

  void uploadImage(XFile xFile) async {
    try {
      final storage = FirebaseStorage.instance;
      Reference ref = storage.ref();
      Reference fileRef =
          ref.child('${DateTime.now().microsecondsSinceEpoch}_${xFile.name}');
      await fileRef.putFile(File(xFile.path));
      String imageUrl = await fileRef.getDownloadURL();
      state = WriteState(state.isWriting, imageUrl);
    } catch (e) {
      print(e);
    }
  }
}

final writeViewModelProvider =
    NotifierProvider.autoDispose.family<WriteViewModel, WriteState, Post?>(() {
  return WriteViewModel();
});
