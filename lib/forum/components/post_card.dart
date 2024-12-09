import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/forum/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.9),
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      color: const Color(0xFFF09027).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      post.createdAt.toString(),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.brown[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              // const SizedBox(height: 12),
              Text(
                post.title,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                post.content,
                style: TextStyle(
                  fontSize: 14.0,
                  height: 1.5,
                  color: Colors.grey[800],
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 16.0),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF8CBEAA).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.comment_outlined,
                      size: 18,
                      color: Colors.teal[700],
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${post.replies.length} Balasan',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.teal[700],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
