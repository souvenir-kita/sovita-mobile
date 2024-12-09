import 'package:flutter/material.dart';
import 'package:sovita/review/widgets/review_card.dart';
import 'package:sovita/review/screens/review_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ulasan Produk',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: ReviewPage(),
    );
  }
}

class ReviewPage extends StatefulWidget {
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final List<Map<String, dynamic>> reviews = [];

  void addReview(String username, int rating, String description, String date) {
    setState(() {
      reviews.add({
        'username': username,
        'rating': rating,
        'description': description,
        'date': date,
      });
    });
  }

  void editReview(
      int index, String username, int rating, String description, String date) {
    setState(() {
      reviews[index] = {
        'username': username,
        'rating': rating,
        'description': description,
        'date': date,
      };
    });
  }

  void deleteReview(int index) {
    setState(() {
      reviews.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ulasan Produk'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Center(
                child: Text(
                  'Ulasan Produk',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormTambahUlasan(),
                    ),
                  );

                  if (result != null && result is Map<String, dynamic>) {
                    addReview(result['username'], result['rating'],
                        result['description'], result['date']);
                  }
                },
                child: Text(
                  'Tambah Ulasan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFF09027),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                ),
              ),
              SizedBox(height: 40),
              reviews.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return ReviewCard(
                          username: review['username'],
                          rating: review['rating'],
                          description: review['description'],
                          date: review['date'],
                          onEdit: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FormTambahUlasan(
                                  initialUsername: review['username'],
                                  initialRating: review['rating'],
                                  initialDescription: review['description'],
                                  initialDate: review['date'],
                                ),
                              ),
                            );
                            if (result != null &&
                                result is Map<String, dynamic>) {
                              editReview(
                                  index,
                                  result['username'],
                                  result['rating'],
                                  result['description'],
                                  result['date']);
                            }
                          },
                          onDelete: () {
                            deleteReview(index);
                          },
                        );
                      },
                    )
                  : Center(
                      child: Text(
                        'Belum ada ulasan.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
