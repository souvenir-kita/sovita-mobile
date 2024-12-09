import 'package:flutter/material.dart';
import 'package:sovita/promo/models/promo.dart';

class PromoDetailPage extends StatelessWidget {
  final Promo promo;

  const PromoDetailPage({Key? key, required this.promo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(promo.fields.nama),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              "Nama: ${promo.fields.nama}",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Kode: ${promo.fields.nama}"),
            const SizedBox(height: 8),
            Text("Potongan:${promo.fields.potongan}"),
            const SizedBox(height: 8),
            Text("Stok: ${promo.fields.stock}"),
            const SizedBox(height: 8),
            Text("Tanggal Akhir Berlaku: ${promo.fields.tanggalAkhirBerlaku}"),
            const SizedBox(height: 8),
            Text("Deskripsi: ${promo.fields.deskripsi}"),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}