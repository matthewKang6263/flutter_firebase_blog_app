import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';

class PostRepository {
  final _postCollection = FirebaseFirestore.instance.collection('posts');

  // 모든 게시물 스트림 가져오기
  Stream<List<Post>> postListStream() {
    return _postCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // ID 추가
        return Post.fromJson(data);
      }).toList();
    });
  }

  // 단일 게시물 스트림 가져오기
  Stream<Post?> postStream(String id) {
    return _postCollection.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Post.fromJson(data);
      }
      return null;
    });
  }

  // 게시물 추가
  Future<bool> insert({
    required String title,
    required String content,
    required String writer,
    required String imageUrl,
  }) async {
    try {
      await _postCollection.add({
        'title': title,
        'content': content,
        'writer': writer,
        'imageUrl': imageUrl,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error inserting post: $e');
      return false;
    }
  }

  // 게시물 수정
  Future<bool> update({
    required String id,
    required String title,
    required String content,
    required String writer,
    required String imageUrl,
  }) async {
    try {
      await _postCollection.doc(id).update({
        'title': title,
        'content': content,
        'writer': writer,
        'imageUrl': imageUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      print('Error updating post: $e');
      return false;
    }
  }

  // 게시물 삭제
  Future<bool> delete(String id) async {
    try {
      await _postCollection.doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting post: $e');
      return false;
    }
  }
}
