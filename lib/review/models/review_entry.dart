import 'dart:convert';

List<ReviewEntry> reviewEntryFromJson(String str) => List<ReviewEntry>.from(
    json.decode(str).map((x) => ReviewEntry.fromJson(x)));

String reviewEntryToJson(List<ReviewEntry> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewEntry {
  String pk;
  Fields fields;

  ReviewEntry({
    required this.pk,
    required this.fields,
  });

  factory ReviewEntry.fromJson(Map<String, dynamic> json) => ReviewEntry(
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  int rating;
  String deskripsi;
  String dateCreate;
  User user;

  Fields({
    required this.rating,
    required this.deskripsi,
    required this.dateCreate,
    required this.user,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        rating: json["rating"],
        deskripsi: json["deskripsi"],
        dateCreate: json["date_create"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "deskripsi": deskripsi,
        "date_create": dateCreate,
        "user": user.toJson(),
      };
}

class User {
  String username;

  User({
    required this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
      };
}
