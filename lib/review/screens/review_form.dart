import 'package:flutter/material.dart';

class FormTambahUlasan extends StatelessWidget {
  const FormTambahUlasan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Ulasan'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Rating
            const Text(
              'Rating:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pilih Rating',
              ),
              items: List.generate(10, (index) {
                return DropdownMenuItem<int>(
                  value: index + 1,
                  child: Text('${index + 1}'),
                );
              }),
              onChanged: (value) {
                // Handle rating selection here
              },
            ),
            const SizedBox(height: 16),

            // Komentar
            const Text(
              'Komentar:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Tulis ulasan Anda...',
              ),
              maxLines: 5,
              onChanged: (value) {
                // Handle komentar change here
              },
            ),
            const SizedBox(height: 24),

            // Button Submit
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic to submit review (not implemented yet)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Ulasan berhasil ditambahkan')),
                  );
                },
                child: const Text('Kirim Ulasan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
