import 'package:flutter/material.dart';

// Widget untuk menampilkan kartu ulasan
class ReviewCard extends StatelessWidget {
  final String username;
  final int rating;
  final String description;
  final String date;

  const ReviewCard({
    Key? key,
    required this.username,
    required this.rating,
    required this.description,
    required this.date,
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
          ],
        ),
      ),
    );
  }
}
