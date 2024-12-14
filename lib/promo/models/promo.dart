// To parse this JSON data, do
//
//     final promo = promoFromJson(jsonString);

import 'dart:convert';

List<Promo> promoFromJson(String str) => List<Promo>.from(json.decode(str).map((x) => Promo.fromJson(x)));

String promoToJson(List<Promo> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Promo {
    String model;
    String pk;
    Fields fields;

    Promo({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    int user;
    String kode;
    String nama;
    int potongan;
    int stock;
    String deskripsi;
    String tanggalAkhirBerlaku;

    Fields({
        required this.user,
        required this.kode,
        required this.nama,
        required this.potongan,
        required this.stock,
        required this.deskripsi,
        required this.tanggalAkhirBerlaku,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        kode: json["kode"],
        nama: json["nama"],
        potongan: json["potongan"],
        stock: json["stock"],
        deskripsi: json["deskripsi"],
        tanggalAkhirBerlaku: json["tanggal_akhir_berlaku"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "kode": kode,
        "nama": nama,
        "potongan": potongan,
        "stock": stock,
        "deskripsi": deskripsi,
        "tanggal_akhir_berlaku": tanggalAkhirBerlaku,
    };
}
