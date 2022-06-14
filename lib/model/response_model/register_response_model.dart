// To parse this JSON data, do
//
//     final registerResponseModel = registerResponseModelFromJson(jsonString);

import 'dart:convert';

RegisterResponseModel registerResponseModelFromJson(String str) =>
    RegisterResponseModel.fromJson(json.decode(str));

String registerResponseModelToJson(RegisterResponseModel data) =>
    json.encode(data.toJson());

class RegisterResponseModel {
  RegisterResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  dynamic data;

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      RegisterResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: json["data"].runtimeType.toString() == 'List<dynamic>'
            ? List<dynamic>.from(json["data"].map((x) => x))
            : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.id,
    this.fname,
    this.lname,
    this.name,
    this.birthday,
    this.username,
    this.email,
    this.password,
    this.gender,
    this.age,
    this.weight,
    this.experienceLevel,
    this.phone,
    this.profilePic,
    this.isVerify,
    this.isBlocked,
    this.createdAt,
  });

  String? id;
  String? fname;
  String? lname;
  String? name;
  DateTime? birthday;
  String? username;
  String? email;
  String? password;
  String? gender;
  String? age;
  String? weight;
  String? experienceLevel;
  String? phone;
  dynamic profilePic;
  String? isVerify;
  String? isBlocked;
  DateTime? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        fname: json["fname"],
        lname: json["lname"],
        name: json["name"],
        birthday: DateTime.parse(json["birthday"]),
        username: json["username"],
        email: json["email"],
        password: json["password"],
        gender: json["gender"],
        age: json["age"],
        weight: json["weight"],
        experienceLevel: json["experience_level"],
        phone: json["phone"],
        profilePic: json["profile_pic"],
        isVerify: json["is_verify"],
        isBlocked: json["is_blocked"],
        createdAt: DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fname": fname,
        "lname": lname,
        "name": name,
        "birthday":
            "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}",
        "username": username,
        "email": email,
        "password": password,
        "gender": gender,
        "age": age,
        "weight": weight,
        "experience_level": experienceLevel,
        "phone": phone,
        "profile_pic": profilePic,
        "is_verify": isVerify,
        "is_blocked": isBlocked,
        "created_at": createdAt!.toIso8601String(),
      };
}
