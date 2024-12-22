import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/bottomsheet/bottomsheet.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:sovita/promo/models/promo.dart';
import 'package:sovita/promo/screens/promo_screen.dart';
import 'package:sovita/promo/widgets/promo_card.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class PromoDetailPage extends StatefulWidget {
  final Promo promo;

  const PromoDetailPage({Key? key, required this.promo}) : super(key: key);

  @override
  State<PromoDetailPage> createState() => _PromoDetailPageState();
}

class _PromoDetailPageState extends State<PromoDetailPage> {
  bool isEditing = false;
  late TextEditingController namaController;
  late TextEditingController kodeController;
  late TextEditingController potonganController;
  late TextEditingController stokController;
  late TextEditingController tanggalController;
  late TextEditingController deskripsiController;
  DateTime? selectedDate;

  @override
  void initState() {
    super.initState();
    namaController = TextEditingController(text: widget.promo.fields.nama);
    kodeController = TextEditingController(text: widget.promo.fields.kode);
    potonganController =
        TextEditingController(text: widget.promo.fields.potongan.toString());
    stokController =
        TextEditingController(text: widget.promo.fields.stock.toString());
    tanggalController =
        TextEditingController(text: widget.promo.fields.tanggalAkhirBerlaku);
    deskripsiController =
        TextEditingController(text: widget.promo.fields.deskripsi);
    selectedDate =
        DateFormat('yyyy-MM-dd').parse(widget.promo.fields.tanggalAkhirBerlaku);
  }

  @override
  void dispose() {
    namaController.dispose();
    kodeController.dispose();
    potonganController.dispose();
    stokController.dispose();
    tanggalController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  void toggleEditMode() {
    setState(() {
      isEditing = !isEditing;
      // Perbarui objek promo lokal di setState untuk memastikan UI ter-update
      widget.promo.fields.nama = namaController.text;
      widget.promo.fields.kode = kodeController.text;
      widget.promo.fields.potongan = int.tryParse(potonganController.text) ?? 0;
      widget.promo.fields.stock = int.tryParse(stokController.text) ?? 0;
      widget.promo.fields.deskripsi = deskripsiController.text;
      widget.promo.fields.tanggalAkhirBerlaku = tanggalController.text;
    });
  }

  void cancelEdit() {
    setState(() {
      isEditing = !isEditing;
      namaController = TextEditingController(text: widget.promo.fields.nama);
      kodeController = TextEditingController(text: widget.promo.fields.kode);
      potonganController =
          TextEditingController(text: widget.promo.fields.potongan.toString());
      stokController =
          TextEditingController(text: widget.promo.fields.stock.toString());
      tanggalController =
          TextEditingController(text: widget.promo.fields.tanggalAkhirBerlaku);
      deskripsiController =
          TextEditingController(text: widget.promo.fields.deskripsi);
      selectedDate = DateFormat('yyyy-MM-dd')
          .parse(widget.promo.fields.tanggalAkhirBerlaku);
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  bool validateEdit() {
    // validasi nama
    if (namaController.text.length > 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh lebih dari 20 huruf!")),
      );
      return false;
    }
    if (namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nama tidak boleh kosong!")),
      );
      return false;
    }
    if (namaController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Nama tidak boleh kurang dari empat huruf!")),
      );
      return false;
    }

    // validasi kode
    if (kodeController.text.length > 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode tidak boleh lebih dari 15 huruf!")),
      );
      return false;
    }
    if (kodeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Kode tidak boleh kosong!")),
      );
      return false;
    }
    if (kodeController.text.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Kode tidak boleh kurang dari empat huruf!")),
      );
      return false;
    }

    // validasi stock
    if (stokController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok tidak boleh kosong")),
      );
      return false;
    }
    if (!stokController.text.isNum) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok harus merupakan angka!")),
      );
      return false;
    }
    if (int.tryParse(stokController.text)! < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Stok tidak boleh negatif!")),
      );
      return false;
    }

    // validasi potongan
    if (potonganController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Potongan tidak boleh kosong")),
      );
      return false;
    }
    if (!potonganController.text.isNum) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Potongan harus merupakan angka!")),
      );
      return false;
    }
    if (int.tryParse(potonganController.text)! < 0 ||
        int.tryParse(potonganController.text)! > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                "Potongan tidak boleh negatif dan tidak boleh lebih dari 100!")),
      );
      return false;
    }

    // validasi deskripsi
    if (deskripsiController.text.length > 256) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Deskripsi tidak boleh lebih dari 256 huruf!")),
      );
      return false;
    }
    if (deskripsiController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Deskripsi tidak boleh kosong!")),
      );
      return false;
    }

    return true;
  }

  Future<void> saveChanges(BuildContext context) async {
    final request = context.read<CookieRequest>();

    if (!validateEdit()) {
      return;
    }

    try {
      final response = await request.postJson(
          "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/promo/edit-flutter/${widget.promo.pk}/",
          jsonEncode(<String, String>{
            'nama': namaController.text,
            'kode': kodeController.text,
            'potongan': potonganController.text,
            'stock': stokController.text,
            'deskripsi': deskripsiController.text,
            'tanggal_akhir_berlaku':
                DateFormat('yyyy-MM-dd').format(selectedDate!),
          }));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Promo berhasil diperbarui!")),
        );
        setState(() {
          // Perbarui status edit mode dan objek promo di dalam state
          isEditing = false;
          widget.promo.fields.nama = namaController.text;
          widget.promo.fields.kode = kodeController.text;
          widget.promo.fields.potongan =
              int.tryParse(potonganController.text) ?? 0;
          widget.promo.fields.stock = int.tryParse(stokController.text) ?? 0;
          widget.promo.fields.deskripsi = deskripsiController.text;
          widget.promo.fields.tanggalAkhirBerlaku = tanggalController.text;
        });
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Terjadi kesalahan saat memperbarui promo")),
        );
      }
    }
  }

  void deletePromo(BuildContext context) async {
    final request = context.read<CookieRequest>();

    try {
      final response = await request.post(
        "https://muhammad-rafli33-souvenirkita.pbp.cs.ui.ac.id/promo/delete-flutter/${widget.promo.pk}/",
        {},
      );

      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const PromoPage()));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Promo berhasil dihapus!")),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Terjadi kesalahan saat menghapus promo")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height:
            MediaQuery.of(context).size.height, // Sesuaikan tinggi dengan layar
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF09027), Color(0xFF8CBEAA)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (!isEditing)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PromoPage()));
                      },
                    ),
                  ),
                ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: PromoCard(promo: widget.promo),
                  ),
                ],
              ),
              Container(
                transform: Matrix4.translationValues(0, -30, 0),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (isEditing)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.edit,
                                      size: 16, color: Colors.blue),
                                  SizedBox(width: 4),
                                  Text(
                                    "Mode Edit",
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildDetailCard(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: isEditing
          ? Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  onPressed: () => cancelEdit(),
                  child: const Icon(Icons.cancel),
                  backgroundColor: Colors.red,
                  tooltip: 'Cancel Changes',
                ),
                SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: () => saveChanges(context),
                  child: const Icon(Icons.check_box),
                  backgroundColor: Colors.blue,
                  tooltip: 'Save Changes',
                ),
              ],
            )
          : _buildActionButtons(context),
    );
  }

  Widget _buildDetailCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0x80D9D9D9),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildEditableField("Nama Promo", namaController, Icons.local_offer),
          _buildEditableField("Kode Promo", kodeController, Icons.code),
          _buildEditableField("Potongan", potonganController, Icons.discount,
              keyboardType: TextInputType.number, suffix: "%"),
          _buildEditableField("Stok", stokController, Icons.inventory,
              keyboardType: TextInputType.number),
          _buildDateField(context),
          _buildEditableField(
              "Deskripsi", deskripsiController, Icons.description,
              maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.calendar_today, color: Colors.blue, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Berlaku Sampai",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                if (isEditing)
                  InkWell(
                    onTap: () => selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors
                                .grey.shade300), // Menambahkan border di sini
                        borderRadius:
                            BorderRadius.circular(8), // Corner yang melengkung
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            tanggalController.text.isNotEmpty
                                ? tanggalController.text
                                : 'Pilih Tanggal',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Icon(Icons.calendar_month),
                        ],
                      ),
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 170, 170, 170)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          tanggalController.text,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField(
    String label,
    TextEditingController controller,
    IconData icon, {
    String? suffix,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLines: maxLines,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: const TextStyle(
                  color: Colors.black,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                suffixText: suffix,
              ),
              enabled: isEditing,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: () => toggleEditMode(),
          icon: const Icon(Icons.edit),
          color: Colors.blue,
        ),
        IconButton(
          onPressed: () => deletePromo(context),
          icon: const Icon(Icons.delete),
          color: Colors.red,
        ),
      ],
    );
  }
}
