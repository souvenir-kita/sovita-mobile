import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/promo/models/promo.dart';
import 'package:sovita/promo/screens/promo_detail.dart';
import 'package:sovita/promo/screens/promo_form.dart';
import 'package:sovita/widget/navigation_menu.dart';

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
  
  Future<void> deletePromo(CookieRequest request, String promoId) async {
  final response = await request.post(
    'http://127.0.0.1:8000/promo/delete-flutter/$promoId/',
    {}, // Body kosong
  );

  if (response['status'] == 'success') {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Promo berhasil dihapus!")),
    );
    setState(() {}); // Refresh tampilan setelah penghapusan
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Gagal menghapus promo.")),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Promo List'),
      ),
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
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
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
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PromoForm(
                                          promo: snapshot.data![index],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () async {
                                    final confirm = await showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Konfirmasi'),
                                        content: const Text('Apakah Anda yakin ingin menghapus promo ini?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, false),
                                            child: const Text('Batal'),
                                          ),
                                          TextButton(
                                            onPressed: () => Navigator.pop(context, true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) {
                                      await deletePromo(request, snapshot.data![index].pk);
                                    }
                                  },
                                ),
                              ],
                            ),
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