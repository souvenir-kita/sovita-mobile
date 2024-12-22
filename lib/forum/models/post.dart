import 'reply.dart';

class Post {
  final String id;
  final String user;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Reply> replies;

  Post({
    required this.id,
    required this.user,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    required this.replies,
  });

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        id: json['id'],
        user: json['user'],
        title: json['title'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        replies: (json['replies'] as List)
            .map((reply) => Reply.fromJson(reply))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'title': title,
        'content': content,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'replies': replies.map((e) => e.toJson()).toList(),
      };
}
