import 'package:flutter/material.dart';

class ReviewCard extends StatelessWidget {
  final String username;
  final int rating;
  final String description;
  final String date;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ReviewCard({
    Key? key,
    required this.username,
    required this.rating,
    required this.description,
    required this.date,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.6),
      shadowColor: Colors.black.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              username,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rating: ' + '⭐' * rating,
              style: TextStyle(color: Colors.yellow, fontSize: 16),
            ),
            Text(
              'Deskripsi: $description',
              style: TextStyle(fontSize: 14),
            ),
            Text(
              'Dibuat: $date',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
