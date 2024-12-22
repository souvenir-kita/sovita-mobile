import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/forum/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final Function onTap;
  final Function onUpdate;
  final Function onDelete;

  const PostCard({
    super.key,
    required this.post,
    required this.onTap,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.9),
      child: InkWell(
        onTap: () {
          onTap();
        },
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
                      DateFormat('d MMM y').format(post.createdAt),
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.brown[800],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  if (request.loggedIn &&
                      request.jsonData['username'] == post.user) ...[
                    IconButton(
                      onPressed: () {
                        onUpdate();
                      },
                      icon: const Icon(Icons.edit_outlined),
                      tooltip: 'Edit diskusi',
                      style: IconButton.styleFrom(
                        foregroundColor: const Color(0xFF8CBEAA),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        onDelete();
                      },
                      icon: const Icon(Icons.delete_outline),
                      tooltip: 'Hapus diskusi',
                      style: IconButton.styleFrom(
                        foregroundColor: Colors.red[400],
                      ),
                    ),
                  ],
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
