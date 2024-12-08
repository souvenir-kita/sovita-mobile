import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:sovita/promo/screens/promo_screen.dart';

class PromoForm extends StatefulWidget {
  const PromoForm({super.key});

  @override
  State<PromoForm> createState() => _PromoFormState();
}

class _PromoFormState extends State<PromoForm> {
  final _formKey = GlobalKey<FormState>();
  String _nama = "";
  String _kode = "";
  int _potongan = 0;
  int _stock = 0;
  String _deskripsi = "";
  DateTime? _tanggalAkhirBerlaku;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), // Tanggal pertama yang bisa dipilih
      lastDate: DateTime(2101),  // Tanggal terakhir yang bisa dipilih
    );

    if (picked != null && picked != _tanggalAkhirBerlaku) {
      setState(() {
        _tanggalAkhirBerlaku = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'From tambah promo',
          ),
        ),
        backgroundColor: Color.fromARGB(255, 245, 222, 179),
        foregroundColor: Colors.white,
      ),
      // drawer: const LeftDrawer(),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _nama = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong!";
                  }
                  if (value.length > 20) {
                    return "Nama tidak boleh lebih dari 20 huruf!";
                  }
                  if (value.length < 4) {
                    return "Nama tidak boleh kurang dari 4 huruf!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Kode",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _kode = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Kode tidak boleh kosong!";
                  }
                  if (value.length > 20) {
                    return "Kode tidak boleh lebih dari 20 huruf!";
                  }
                  if (value.length < 4) {
                    return "Kode tidak boleh kurang dari 4 huruf!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Stok",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _stock = int.tryParse(value!) ?? 0;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Stock tidak boleh kosong!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Stock harus berupa angka!";
                  }
                  if (int.tryParse(value)! < 0) {
                    return "Stock harus berupa angka tidak negatif!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Potongan (%)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _potongan = int.tryParse(value!) ?? 0;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Potongan tidak boleh kosong!";
                  }
                  if (int.tryParse(value) == null) {
                    return "Potongan harus berupa angka!";
                  }
                  if (int.tryParse(value)! < 0) {
                    return "Potongan harus berupa angka tidak negatif!";
                  }
                  if (int.tryParse(value)! > 100) {
                    return "Potongan tidak boleh melebihi 100!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _deskripsi = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Deskripsi tidak boleh kosong!";
                  }
                  if (value.length > 256) {
                    return "Deskripsi tidak boleh lebih dari 256 huruf!";
                  }
                  return null;
                },
              ),
            ),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => _selectDate(context), 
                    child: const Text('Pilih Tanggal Akhir Berlaku'),
                    ),
                  const SizedBox(height: 20),

                  if (_tanggalAkhirBerlaku != null)
                    Text(
                      'Tanggal Akhir Berlaku: ${DateFormat('yyyy-MM-dd').format(_tanggalAkhirBerlaku!)}',
                    )
                  
                  else
                    const Text(
                      'Belum ada tanggal yang dipilih',
                      style: TextStyle(fontSize: 18),
                    )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        Theme.of(context).colorScheme.primary),
                  ),
              onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                          "http://127.0.0.1:8000/promo/create-flutter/",
                          jsonEncode(<String, String>{
                              'nama': _nama,
                              'kode': _kode,
                              'potongan' : _potongan.toString(),
                              'stock' : _stock.toString(),
                              'deskripsi' : _deskripsi,
                              'tanggal_akhir_berlaku' : DateFormat('yyyy-MM-dd').format(_tanggalAkhirBerlaku!)  
                          }),
                      );
                      if (context.mounted) {
                          if (response['status'] == 'success') {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                              content: Text("Mood baru berhasil disimpan!"),
                              ));
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => PromoPage()),
                              );
                          } else {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content:
                                      Text("Terdapat kesalahan, silakan coba lagi."),
                              ));
                          }
                      }
                  }
},
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}