import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:sovita/forum/components/post_card.dart';
import 'package:sovita/forum/models/post.dart';

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
      body: SafeArea(
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
                ),
              );
            },
          ),
        ),
    );
  }
}
