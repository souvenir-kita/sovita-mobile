// To parse this JSON data, do
//
//     final cart = cartFromJson(jsonString);

import 'dart:convert';

List<Cart> cartFromJson(String str) =>
    List<Cart>.from(json.decode(str).map((x) => Cart.fromJson(x)));

String cartToJson(List<Cart> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Cart {
  String model;
  String pk;
  CartFields fields;

  Cart({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        model: json["model"],
        pk: json["pk"],
        fields: CartFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class CartFields {
  String pk;
  int user;
  DateTime createdAt;

  CartFields({
    required this.pk,
    required this.user,
    required this.createdAt,
  });

  factory CartFields.fromJson(Map<String, dynamic> json) => CartFields(
        pk: json["pk"],
        user: json["user"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "user": user,
        "created_at": createdAt.toIso8601String(),
      };
}
