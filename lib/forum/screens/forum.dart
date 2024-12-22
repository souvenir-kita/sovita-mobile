import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/forum/models/post.dart';
import 'package:sovita/forum/screens/forum_detail.dart';
import 'package:sovita/forum/screens/post_form.dart';
import 'package:sovita/forum/components/post_card.dart';

class ForumPage extends StatefulWidget {
  final String productId;

  const ForumPage({super.key, required this.productId});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Future<List<Post>> fetchPosts(CookieRequest request) async {
    final response = await request
        .get("http://localhost:8000/forum/flutter/${widget.productId}");

    return (response['data']['posts'] as List)
        .map((d) => Post.fromJson(d))
        .toList();
  }

  void _refreshPage() {
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
      floatingActionButton:
          request.loggedIn && !request.getJsonData()['isAdmin']
              ? FloatingActionButton.extended(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostForm(
                          formName: "Buat Diskusi Baru",
                          initialTitle: "",
                          initialContent: "",
                          onSubmit: (title, content) async {
                            final response = await request.postJson(
                              "http://localhost:8000/forum/flutter/${widget.productId}/create",
                              jsonEncode(<String, String>{
                                'title': title,
                                'content': content,
                              }),
                            );
                            if (context.mounted) {
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Post baru berhasil disimpan!"),
                                ));
                                _refreshPage();
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Terdapat kesalahan, silakan coba lagi."),
                                ));
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Tambah Diskusi'),
                  backgroundColor: const Color(0xFF8CBEAA),
                )
              : null,
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
            future: fetchPosts(request),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return const Center(
                  child: Text(
                    'Belum ada diskusi',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              final List<Post> posts = snapshot.data!;
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (_, index) => PostCard(
                  post: posts[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ForumDetailPage(
                          productId: widget.productId,
                          postId: posts[index].id,
                          setForumState: () {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                  onUpdate: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostForm(
                          formName: "Edit Diskusi",
                          initialTitle: posts[index].title,
                          initialContent: posts[index].content,
                          onSubmit: (title, content) async {
                            final response = await request.postJson(
                              "http://localhost:8000/forum/flutter/${widget.productId}/${posts[index].id}/update",
                              jsonEncode(<String, String>{
                                'title': title,
                                'content': content,
                              }),
                            );
                            if (context.mounted) {
                              if (response['status'] == 'success') {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text("Post berhasil diupdate!"),
                                ));
                                _refreshPage();
                                Navigator.pop(context);
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      "Terdapat kesalahan, silakan coba lagi."),
                                ));
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                  onDelete: () async {
                    final response = await request.postJson(
                      "http://localhost:8000/forum/flutter/${widget.productId}/${posts[index].id}/delete",
                      jsonEncode({}),
                    );
                    if (context.mounted) {
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Post berhasil dihapus!"),
                        ));
                        _refreshPage();
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    }
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
