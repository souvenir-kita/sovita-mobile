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
  String? selectedTimeFilter;

  // Map untuk konversi filter ke hours
  final Map<String, int> timeFilters = {
    '3 jam': 3,
    '12 jam': 12,
    '1 hari': 24,
    '3 hari': 72,
    '7 hari': 168,
  };

  Future<List<Post>> fetchPosts(CookieRequest request) async {
    final response = await request
        .get("https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}");

    List<Post> posts = (response['data']['posts'] as List)
        .map((d) => Post.fromJson(d))
        .toList();

    if (selectedTimeFilter != null) {
      final filterHours = timeFilters[selectedTimeFilter!]!;
      final DateTime filterTime =
          DateTime.now().subtract(Duration(hours: filterHours));

      posts = posts.where((post) {
        final postDate = post.createdAt;
        return postDate.isBefore(filterTime);
      }).toList();
    }

    return posts;
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
                              "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/create",
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
          child: Column(
            children: [
              // Filter Section
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      'Filter Waktu',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectedTimeFilter,
                            hint: const Text(
                              'Filter waktu',
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: const Icon(Icons.access_time,
                                color: Colors.white),
                            dropdownColor: const Color(0xFF8CBEAA),
                            borderRadius: BorderRadius.circular(8),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedTimeFilter = newValue;
                              });
                            },
                            items: [
                              const DropdownMenuItem<String>(
                                value: null,
                                child: Text('Semua'),
                              ),
                              ...timeFilters.keys.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  );
                                },
                              ).toList(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
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
                    if (posts.isEmpty) {
                      return Center(
                        child: Text(
                          selectedTimeFilter != null
                              ? 'Tidak ada diskusi yang lebih dari $selectedTimeFilter' // Filtered empty state
                              : 'Belum ada diskusi', // Should not reach here normally
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }
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
                                    "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/${posts[index].id}/update",
                                    jsonEncode(<String, String>{
                                      'title': title,
                                      'content': content,
                                    }),
                                  );
                                  if (context.mounted) {
                                    if (response['status'] == 'success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content:
                                            Text("Post berhasil diupdate!"),
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
                            "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/forum/flutter/${widget.productId}/${posts[index].id}/delete",
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
                                content: Text(
                                    "Terdapat kesalahan, silakan coba lagi."),
                              ));
                            }
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
