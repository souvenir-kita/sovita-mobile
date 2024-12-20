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
  bool includeExpired = true;

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

    final filteredPromos = includeExpired
        ? promos
        : promos.where((promo) {
            final expiryDate = DateTime.parse(promo.fields.tanggalAkhirBerlaku);
            return expiryDate.isAfter(DateTime.now());
          }).toList();

    if (filterBy != null) {
      filteredPromos.sort((a, b) {
        if (filterBy == 'potongan') {
          if (isAscending) {
            return a.fields.potongan.compareTo(b.fields.potongan);
          } else {
            return b.fields.potongan.compareTo(a.fields.potongan);
          }
        } else {
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

    return filteredPromos;
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: const EdgeInsets.all(4),
        child: FutureBuilder(
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return FilterDialog(
                                    filterBy: filterBy,
                                    isAscending: isAscending,
                                    includeExpired: includeExpired,
                                    onFilterChanged: (newFilterBy, newIsAscending) {
                                      setState(() {
                                        filterBy = newFilterBy;
                                        isAscending = newIsAscending;
                                      });
                                    },
                                    onExpiredChanged: (value) {
                                      setState(() {
                                        includeExpired = value;
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.filter_list),
                                const SizedBox(width: 8),
                                Text(filterButtonText),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const PromoForm()),
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
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                if (snapshot.data.length == 0)
                  const EmptyPromoMessage()
                else
                  Expanded(
                    child: Padding(
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
                  ),
              ],
            );
          },
        ),
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

class FilterDialog extends StatefulWidget {
  final String? filterBy;
  final bool isAscending;
  final bool includeExpired;
  final Function(String?, bool) onFilterChanged;
  final Function(bool) onExpiredChanged;

  const FilterDialog({
    Key? key,
    required this.filterBy,
    required this.isAscending,
    required this.includeExpired,
    required this.onFilterChanged,
    required this.onExpiredChanged,
  }) : super(key: key);

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late bool _includeExpired;

  @override
  void initState() {
    super.initState();
    _includeExpired = widget.includeExpired;
  }

  Widget _buildFilterOption({
    required String title,
    required List<FilterOption> options,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: options.map((option) {
            final isSelected =
                widget.filterBy == option.type && widget.isAscending == option.isAscending;
            return FilterChip(
              label: Text(
                option.label,
                style: TextStyle(fontSize: 12),
              ),
              selected: isSelected,
              showCheckmark: false,
              backgroundColor: Colors.grey[200],
              selectedColor: const Color(0xFF59A5D8),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
              onSelected: (bool selected) {
                if (selected) {
                  widget.onFilterChanged(option.type, option.isAscending);
                  Navigator.pop(option.context);
                }
              },
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Tampilkan yang kadaluarsa',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Switch(
                  value: _includeExpired,
                  onChanged: (value) {
                    setState(() {
                      _includeExpired = value;
                    });
                    widget.onExpiredChanged(value);
                  },
                  activeColor: const Color(0xFF59A5D8), 
                  inactiveTrackColor: const Color(0xFFB0BEC5),
                  inactiveThumbColor: const Color.fromARGB(255, 61, 61, 61), 
                )
              ],
            ),
            const Divider(height: 24),
            _buildFilterOption(
              title: 'Berdasarkan Potongan',
              options: [
                FilterOption(
                  context: context,
                  type: 'potongan',
                  isAscending: true,
                  label: 'Terendah ke Tertinggi',
                ),
                FilterOption(
                  context: context,
                  type: 'potongan',
                  isAscending: false,
                  label: 'Tertinggi ke Terendah',
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildFilterOption(
              title: 'Berdasarkan Tanggal Kadaluarsa',
              options: [
                FilterOption(
                  context: context,
                  type: 'tanggal',
                  isAscending: true,
                  label: 'Terlama ke Tercepat',
                ),
                FilterOption(
                  context: context,
                  type: 'tanggal',
                  isAscending: false,
                  label: 'Tercepat ke Terlama',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    widget.onFilterChanged(null, true);
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Reset Filter',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class FilterOption {
  final BuildContext context;
  final String type;
  final bool isAscending;
  final String label;

  FilterOption({
    required this.context,
    required this.type,
    required this.isAscending,
    required this.label,
  });
}
