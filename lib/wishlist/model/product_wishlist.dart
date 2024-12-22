// To parse this JSON data, do
//
//     final Wishlist = WishlistFromJson(jsonString);

import 'dart:convert';

List<Wishlist> wishlistFromJson(String str) => List<Wishlist>.from(json.decode(str).map((x) => Wishlist.fromJson(x)));

String wishlistToJson(List<Wishlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Wishlist {
    String model;
    int pk;
    Fields fields;

    Wishlist({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
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
    String product;
    DateTime addedOn;
    String description;
    int priority;

    Fields({
        required this.user,
        required this.product,
        required this.addedOn,
        required this.description,
        required this.priority,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        user: json["user"],
        product: json["product"],
        addedOn: DateTime.parse(json["added_on"]),
        description: json["description"],
        priority: json["priority"],
    );

    Map<String, dynamic> toJson() => {
        "user": user,
        "product": product,
        "added_on": addedOn.toIso8601String(),
        "description": description,
        "priority": priority,
    };
}
