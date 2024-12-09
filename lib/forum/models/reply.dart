class Reply {
  final String id;
  final String user;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Reply({
    required this.id,
    required this.user,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) => Reply(
        id: json['id'],
        user: json['user'],
        content: json['content'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user': user,
        'content': content,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
      };
}
