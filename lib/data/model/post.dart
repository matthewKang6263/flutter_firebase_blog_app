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

  // JSON에서 Post 객체로 변환
  Post.fromJson(Map<String, dynamic> map)
      : this(
          id: map['id'] ?? '',
          title: map['title'] ?? '',
          content: map['content'] ?? '',
          writer: map['writer'] ?? '',
          imageUrl: map['imageUrl'] ?? '',
          createdAt: (map['createdAt'] as Timestamp).toDate(),
        );

  // Post 객체를 JSON으로 변환
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
