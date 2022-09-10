// To parse this JSON data, do
//
//     final editProfileResponseModel = editProfileResponseModelFromJson(jsonString);

import 'dart:convert';

EditProfileResponseModel editProfileResponseModelFromJson(String str) =>
    EditProfileResponseModel.fromJson(json.decode(str));

String editProfileResponseModelToJson(EditProfileResponseModel data) =>
    json.encode(data.toJson());

class EditProfileResponseModel {
  EditProfileResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<Datum>? data;

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
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
  dynamic? age;
  String? weight;
  String? experienceLevel;
  String? phone;
  String? profilePic;
  String? isVerify;
  String? isBlocked;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
