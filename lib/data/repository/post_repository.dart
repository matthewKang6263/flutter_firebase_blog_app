import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase_blog_app/data/model/post.dart';

class PostRepository {
  final _postCollection = FirebaseFirestore.instance.collection('posts');

  // Firestore에서 모든 게시물을 스트림으로 가져오기
  Stream<List<Post>> postListStream() {
    return _postCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) {
            final data = doc.data(); // Firestore 데이터 읽기
            data['id'] = doc.id; // 문서 ID 추가
            try {
              return Post.fromJson(data); // Post 객체로 변환
            } catch (e) {
              print("Error mapping post: $e");
              return null; // 매핑 실패 시 null 반환
            }
          })
          .whereType<Post>()
          .toList(); // null 필터링
    });
  }

  // 단일 게시물 스트림 가져오기
  Stream<Post?> postStream(String id) {
    return _postCollection.doc(id).snapshots().map((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        return Post.fromJson(data); // Post 객체로 변환
      }
      return null; // 문서가 존재하지 않으면 null 반환
    });
  }

  // Firestore에 게시물 추가
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
        'createdAt': FieldValue.serverTimestamp(), // 서버 타임스탬프
      });
      return true;
    } catch (e) {
      print('Error inserting post: $e');
      return false;
    }
  }

  // Firestore에서 게시물 수정
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

  // Firestore에서 게시물 삭제
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
