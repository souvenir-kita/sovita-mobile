import 'package:flutter/material.dart';
import 'package:sovita/promo/models/promo.dart';

class PromoCard extends StatelessWidget {
  final Promo promo;

  const PromoCard({
    super.key,
    required this.promo,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.4;
    double height = width * 2 / 3;

    return buildCard(context, width, height);
  }

  Widget buildCard(BuildContext context, double width, double height) {
    final isExpired = kadaluarsa(promo.fields.tanggalAkhirBerlaku);

    return Opacity(
      opacity: isExpired ? 0.5 : 1.0, 
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(8.0),
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
                            color: isExpired ? Colors.grey[300] : Color(0xFFFFF0F0),
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
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Text(
                                  promo.fields.nama,
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.025, 
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1.0),
                                child: Text(
                                  'Kode: ${promo.fields.kode}',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.018,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  'Valid hingga: ${promo.fields.tanggalAkhirBerlaku}',
                                  style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.width * 0.015, 
                                    fontWeight: FontWeight.w600,
                                    color: isExpired ? Colors.grey : Colors.redAccent,
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
                            color: isExpired ? Colors.grey : getColor(promo.fields.potongan),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.local_offer,
                                color: Colors.white,
                                size: MediaQuery.of(context).size.width * 0.06, 
                              ),
                              Text(
                                  '${promo.fields.potongan}%',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: MediaQuery.of(context).size.width * 0.035, 
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
          Icon(
            Icons.local_offer,
            color: Colors.blue,
            size: MediaQuery.of(context).size.width * 0.08, // Ukuran ikon responsif
          ),
          const SizedBox(width: 8),
          Text(
            "Promo Details",
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * 0.05, // Ukuran font responsif
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text(
            "Close",
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

bool kadaluarsa(String tanggalKadaluarsa) {
  DateTime tanggal = DateTime.parse(tanggalKadaluarsa);
  DateTime sekarang = DateTime.now();

  tanggal = DateTime(tanggal.year, tanggal.month, tanggal.day);
  sekarang = DateTime(sekarang.year, sekarang.month, sekarang.day);
  return (tanggal.isBefore(sekarang)) ? true : false;
} 