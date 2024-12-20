import 'package:flutter/material.dart';
import 'package:sovita/promo/models/promo.dart';

class PromoCard extends StatelessWidget {
  final Promo promo;
  final Future<void> Function(String promoId) onDelete;

  const PromoCard({
    super.key,
    required this.promo,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.4;
    double height = width * 2 / 3;

    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PromoDialog(promo: promo);
          },
        );
      },
      child: buildCard(context, width, height),
    );
  }

  Widget buildCard(BuildContext context, double width, double height) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(8.0),
      child: AspectRatio(
        aspectRatio: 3 / 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color(0xFFFFF0F0),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                promo.fields.nama,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Kode: ${promo.fields.kode}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                'Valid hingga: ${promo.fields.tanggalAkhirBerlaku.toString()}',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.redAccent,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: getColor(promo.fields.potongan),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.local_offer,
                                color: Colors.white, size: 40),
                            Text(
                              '${promo.fields.potongan}%',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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

Color getColor(int potongan) {
  if (potongan <= 25) {
    return Color(0xFF4E9B00);
  } else if (potongan <= 75) {
    return Color(0xFFFF6E20);
  } else {
    return Color(0xFF9812FF);
  }
}

class PromoDialog extends StatelessWidget {
  final Promo promo;

  const PromoDialog({
    super.key,
    required this.promo,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: Row(
        children: [
          Icon(Icons.local_offer, color: Colors.blue, size: 28),
          const SizedBox(width: 8),
          Text(
            "Promo Details",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoText("Nama", promo.fields.nama),
            _buildInfoText("Kode", promo.fields.kode),
            _buildInfoText("Potongan", "${promo.fields.potongan}%"),
            _buildInfoText("Stok", promo.fields.stock.toString()),
            _buildInfoText("Tanggal Akhir Berlaku",
                promo.fields.tanggalAkhirBerlaku.toString()),
            _buildInfoText("Deskripsi", promo.fields.deskripsi),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context)
                .pop(); // Close the dialog when the button is pressed
          },
          child: Text(
            "Close",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }
}
