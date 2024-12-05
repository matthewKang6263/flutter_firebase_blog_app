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

  Post.fromJson(Map<String, dynamic> map)
      : this(
          id: map['id'],
          title: map['title'],
          content: map['content'],
          writer: map['writer'],
          imageUrl: map['imageUrl'],
          createdAt: DateTime.parse(map['createdAt']),
        );
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'writer': writer,
      'imageUrl': imageUrl,
      'createAt': createdAt.toIso8601String(),
    };
  }
}
