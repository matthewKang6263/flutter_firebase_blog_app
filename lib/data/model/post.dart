import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  String title;
  String content;
  String writer;
  String imageUrl;
  DateTime createdAt;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.writer,
    required this.imageUrl,
    required this.createdAt,
  });

  // Firestore 데이터(Map)를 Post 객체로 변환
  Post.fromJson(Map<String, dynamic> map)
      : this(
          id: map['id'] ?? '', // Firestore 문서 ID
          title: map['title'] ?? '',
          content: map['content'] ?? '',
          writer: map['writer'] ?? '',
          imageUrl: map['imageUrl'] ?? '',
          // createdAt 필드가 없거나 null인 경우 기본값 처리
          createdAt: map['createdAt'] != null
              ? (map['createdAt'] as Timestamp).toDate()
              : DateTime.now(),
        );

  // Post 객체를 Firestore에 저장 가능한 JSON 형태로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'writer': writer,
      'imageUrl': imageUrl,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
