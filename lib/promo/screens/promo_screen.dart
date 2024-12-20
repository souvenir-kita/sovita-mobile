import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/promo/screens/helper/fetch_promo.dart';
import 'package:sovita/promo/screens/promo_form.dart';
import 'package:sovita/promo/widgets/promo_card.dart';

class PromoPage extends StatefulWidget {
  const PromoPage({super.key});

  @override
  State<PromoPage> createState() => _PromoPageState();
}

class _PromoPageState extends State<PromoPage> {
  String? filterBy;
  bool isAscending = true;
  
  String get filterButtonText {
    if (filterBy == null) return 'Filter';
    
    if (filterBy == 'potongan') {
      return isAscending ? 'Potongan Terkecil' : 'Potongan Terbesar';
    } else {
      return isAscending ? 'Kadaluarsa Terlama' : 'Kadaluarsa Tercepat';
    }
  }

  Future<List<dynamic>> getSortedPromos(CookieRequest request) async {
    final promos = await fetchPromo(request);
    
    if (filterBy != null) {
      promos.sort((a, b) {
        if (filterBy == 'potongan') {
          if (isAscending) {
            return a.fields.potongan.compareTo(b.fields.potongan);
          } else {
            return b.fields.potongan.compareTo(a.fields.potongan);
          }
        } else { // tanggal
          if (isAscending) {
            return DateTime.parse(a.fields.tanggalAkhirBerlaku)
                .compareTo(DateTime.parse(b.fields.tanggalAkhirBerlaku));
          } else {
            return DateTime.parse(b.fields.tanggalAkhirBerlaku)
                .compareTo(DateTime.parse(a.fields.tanggalAkhirBerlaku));
          }
        }
      });
    }
    
    return promos;
  }

  Future<void> deletePromo(CookieRequest request, String promoId) async {
    final response = await request.post(
      'http://127.0.0.1:8000/promo/delete-flutter/$promoId/',
      {},
    );

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Promo berhasil dihapus!")),
      );
      setState(() {});
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
        future: getSortedPromos(request),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    PopupMenuButton<Map<String, dynamic>>(
                      onSelected: (Map<String, dynamic> result) {
                        setState(() {
                          filterBy = result['filterBy'];
                          isAscending = result['isAscending'];
                        });
                      },
                      itemBuilder: (BuildContext context) => [
                        PopupMenuItem(
                          value: {'filterBy': 'potongan', 'isAscending': true},
                          child: const Text('Potongan Harga (A-Z)'),
                        ),
                        PopupMenuItem(
                          value: {'filterBy': 'potongan', 'isAscending': false},
                          child: const Text('Potongan Harga (Z-A)'),
                        ),
                        PopupMenuItem(
                          value: {'filterBy': 'tanggal', 'isAscending': true},
                          child: const Text('Tanggal (Terlama)'),
                        ),
                        PopupMenuItem(
                          value: {'filterBy': 'tanggal', 'isAscending': false},
                          child: const Text('Tanggal (Terbaru)'),
                        ),
                      ],
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).elevatedButtonTheme.style?.backgroundColor?.resolve({}) 
                              ?? Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.filter_list, color: Colors.white),
                            const SizedBox(width: 8),
                            Text(
                              filterButtonText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PromoForm()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (snapshot.data.length == 0)
                const EmptyPromoMessage()
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 4 / 2,
                    ),
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return PromoCard(
                        promo: snapshot.data[index],
                        onDelete: (id) => deletePromo(request, id),
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class EmptyPromoMessage extends StatelessWidget {
  const EmptyPromoMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Belum ada data Promo.',
          style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
        ),
        SizedBox(height: 8),
      ],
    );
  }
}