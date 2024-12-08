import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/promo/models/promo.dart';
import 'package:sovita/promo/screens/promo_detail.dart';
import 'package:sovita/promo/screens/promo_form.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  Future<List<Promo>> fetchProduct(CookieRequest request) async {
    final response = await request.get('http://127.0.0.1:8000/promo/json_api/');
    
    // Melakukan decode response menjadi bentuk json
    var data = response;

    List<Promo> listPromo = [];
    for (var d in data) {
      if (d != null) {
        listPromo.add(Promo.fromJson(d));
      }
    }
    return listPromo;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo List'),
      ),
      // drawer: const LeftDrawer(),
      body: FutureBuilder(
        future: fetchProduct(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    print('Button ditekan!');
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PromoForm()),
                    );
                  },
                  child: const Text('Tambah Promo'),
                ),
              ),
              const SizedBox(height: 16),
              if (snapshot.data.length == 0) ...[
                const Text(
                  'Belum ada data Promo.',
                  style: TextStyle(
                    fontSize: 20, 
                    color: Color(0xff59A5D8)
                  ), 
                ),
                const SizedBox(height: 8),
              ] else ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PromoDetailPage(
                              promo: snapshot.data![index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16, 
                          vertical: 12
                        ),
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6.0,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.data![index].fields.nama}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("Kode: ${snapshot.data![index].fields.kode}"),
                            const SizedBox(height: 10),
                            Text("Tanggal Akhir Berlaku: ${snapshot.data![index].fields.tanggalAkhirBerlaku}"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}