// To parse this JSON data, do
//
//     final userProfile = userProfileFromJson(jsonString);

import 'dart:convert';

UserProfile userProfileFromJson(String str) => UserProfile.fromJson(json.decode(str));

String userProfileToJson(UserProfile data) => json.encode(data.toJson());

class UserProfile {
    String username;
    String role;
    String address;
    int age;
    String phoneNumber;

    UserProfile({
        required this.username,
        required this.role,
        required this.address,
        required this.age,
        required this.phoneNumber,
    });

    factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        username: json["username"],
        role: json["role"],
        address: json["address"],
        age: json["age"],
        phoneNumber: json["phone_number"],
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "role": role,
        "address": address,
        "age": age,
        "phone_number": phoneNumber,
    };
}
