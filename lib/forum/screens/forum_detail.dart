import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/forum/components/reply_card.dart';
import 'package:sovita/forum/models/post.dart';
import 'package:sovita/forum/screens/reply_form.dart';

// Kalo bisa pakai local provider untuk provide post object
class ForumDetailPage extends StatefulWidget {
  final String productId;
  final String postId;
  final Function setForumState;

  const ForumDetailPage(
      {super.key,
      required this.productId,
      required this.postId,
      required this.setForumState});

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
  Future<Post> fetchPost(CookieRequest request) async {
    final response = await request.get(
        "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/${widget.postId}");

    return Post.fromJson(response['data']['post']);
  }

  void _refreshPage() {
    widget.setForumState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Forum Diskusi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFFF09027),
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: FutureBuilder(
            future: fetchPost(request),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFF09027),
                  ),
                );
              }

              final post = snapshot.data!;
              return ListView(
                // padding: const EdgeInsets.only(top: 16),
                children: [
                  // Post Content
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.05),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Diposting oleh ${post.user}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF09027)
                                          .withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      DateFormat('MMM d, y')
                                          .format(post.createdAt),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.brown[800],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                post.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF333333),
                                  height: 1.3,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                post.content,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.6,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReplyForm(
                                        formName: "Tambah Komentar",
                                        initialContent: "",
                                        onSubmit: (content) async {
                                          final response =
                                              await request.postJson(
                                            "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/${widget.postId}/create",
                                            jsonEncode(<String, String>{
                                              'content': content
                                            }),
                                          );
                                          if (context.mounted) {
                                            if (response['status'] ==
                                                'success') {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                    content: Text(
                                                        "Komentar berhasil ditambahkan!")),
                                              );
                                              _refreshPage();
                                              Navigator.pop(context);
                                            }
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey[300]!,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_comment,
                                          size: 20, color: Colors.grey[600]),
                                      const SizedBox(width: 12),
                                      Text(
                                        'Tambah Komentar',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Balasan (${post.replies.length})",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Replies List
                  ...post.replies
                      .map((reply) => ReplyCard(
                            reply: reply,
                            onUpdate: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReplyForm(
                                    formName: "Edit Komentar",
                                    initialContent: reply.content,
                                    onSubmit: (content) async {
                                      final response = await request.postJson(
                                        "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/${widget.postId}/${reply.id}/update",
                                        jsonEncode(<String, String>{
                                          'content': content
                                        }),
                                      );
                                      if (context.mounted) {
                                        if (response['status'] == 'success') {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Komentar berhasil diperbarui!"),
                                            ),
                                          );
                                          _refreshPage();
                                          Navigator.pop(context);
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  "Gagal memperbarui komentar. Silakan coba lagi."),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              );
                            },
                            onDelete: () async {
                              final response = await request.postJson(
                                "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/${widget.postId}/${reply.id}/delete",
                                jsonEncode({}),
                              );
                              if (context.mounted) {
                                if (response['status'] == 'success') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Komentar berhasil dihapus!"),
                                    ),
                                  );
                                  _refreshPage();
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          "Gagal menghapus komentar. Silakan coba lagi."),
                                    ),
                                  );
                                }
                              }
                            },
                          ))
                      .toList(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
