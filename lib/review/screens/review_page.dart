import 'package:flutter/material.dart';
import 'package:sovita/review/widgets/review_card.dart'; // Import ReviewCard
import 'package:sovita/review/screens/review_form.dart'; // Import ReviewCard

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

class ReviewPage extends StatelessWidget {
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
              // Judul Ulasan Produk
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

              // Filter dari Rating (Statik)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Filter dari Rating',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 10),
                  // DropdownButton statis
                  Container(
                    width: 200,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(0xFFF09027),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Semua Ulasan', // Nilai statis yang terlihat
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),

              // Tambah Ulasan Button (Statik) dengan Navigasi
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke FormTambahUlasan
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FormTambahUlasan()),
                  );
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

              // Ulasan List (Statik)
              Container(
                child: Column(
                  children: [
                    ReviewCard(
                        username: 'User1',
                        rating: 5,
                        description: 'Deskripsi ulasan produk ini sangat bagus',
                        date: '2024-12-02'),
                    ReviewCard(
                        username: 'User2',
                        rating: 4,
                        description: 'Produk cukup bagus dan sesuai harapan',
                        date: '2024-12-01'),
                    ReviewCard(
                        username: 'User3',
                        rating: 3,
                        description:
                            'Produk sesuai dengan deskripsi tetapi agak lambat pengiriman',
                        date: '2024-11-30'),
                  ],
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
