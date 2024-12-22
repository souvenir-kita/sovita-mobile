import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/forum/models/reply.dart';

class ReplyCard extends StatelessWidget {
  final Reply reply;
  final Function onUpdate;
  final Function onDelete;

  const ReplyCard(
      {super.key,
      required this.reply,
      required this.onUpdate,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  reply.user,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF8CBEAA).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat('MMM d, y').format(reply.createdAt),
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.teal[700],
                    ),
                  ),
                ),
                const Spacer(),
                if (request.loggedIn &&
                    request.getJsonData()["username"] == reply.user) ...[
                  IconButton(
                    onPressed: () {
                      onUpdate();
                    },
                    icon: const Icon(Icons.edit_outlined),
                    color: Colors.grey[600],
                    tooltip: 'Edit balasan',
                    style: IconButton.styleFrom(
                      foregroundColor: const Color(0xFF8CBEAA),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      onDelete();
                    },
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'Hapus balasan',
                    style: IconButton.styleFrom(
                      foregroundColor: Colors.red[400],
                    ),
                  ),
                ]
              ],
            ),
            const SizedBox(height: 12),
            Text(
              reply.content,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
