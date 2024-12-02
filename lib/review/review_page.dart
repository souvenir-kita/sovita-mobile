import 'package:flutter/material.dart';

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

              // Tambah Ulasan Button (Statik)
              ElevatedButton(
                onPressed: null, // Tidak ada fungsionalitas
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
                    reviewCard(
                        'User1',
                        5,
                        'Deskripsi ulasan produk ini sangat bagus',
                        '2024-12-02'),
                    reviewCard('User2', 4,
                        'Produk cukup bagus dan sesuai harapan', '2024-12-01'),
                    reviewCard(
                        'User3',
                        3,
                        'Produk sesuai dengan deskripsi tetapi agak lambat pengiriman',
                        '2024-11-30'),
                  ],
                ),
              ),

              SizedBox(height: 40),

              // Modal Ulasan (Statik)
              showModalButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget reviewCard(
      String username, int rating, String description, String date) {
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

  Widget showModalButton(BuildContext context) {
    return ElevatedButton(
      onPressed: null, // Tidak ada fungsionalitas
      child: Text('Tambah Ulasan'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFF09027),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      ),
    );
  }
}
