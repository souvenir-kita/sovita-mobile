import 'dart:convert';

List<CartProduct> cartProductFromJson(String str) => 
    List<CartProduct>.from(json.decode(str).map((x) => CartProduct.fromJson(x)));

String cartProductToJson(List<CartProduct> data) => 
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartProduct {
  String model;
  String pk;
  CartProductFields fields;

  CartProduct({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory CartProduct.fromJson(Map<String, dynamic> json) => CartProduct(
        model: json["model"],
        pk: json["pk"],
        fields: CartProductFields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class CartProductFields {
  String cart;
  String product;
  int amount;
  String? note;
  DateTime dateAdded;

  CartProductFields({
    required this.cart,
    required this.product,
    required this.amount,
    this.note,
    required this.dateAdded,
  });

  factory CartProductFields.fromJson(Map<String, dynamic> json) => CartProductFields(
        cart: json["cart"],
        product: json["product"],
        amount: json["amount"],
        note: json["note"],
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "cart": cart,
        "product": product,
        "amount": amount,
        "note": note,
        "date_added": dateAdded.toIso8601String(),
      };
}
