import 'dart:convert';

UserdetailResponseModel userdetailResponseModelFromJson(String str) =>
    UserdetailResponseModel.fromJson(json.decode(str));

String userdetailResponseModelToJson(UserdetailResponseModel data) =>
    json.encode(data.toJson());

class UserdetailResponseModel {
  UserdetailResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory UserdetailResponseModel.fromJson(Map<String, dynamic> json) =>
      UserdetailResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": data!.toJson(),
      };
}

class Data {
  Data({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.age,
    this.gender,
  });

  String? userId;
  String? name;
  String? email;
  String? phone;
  String? age;
  String? gender;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        age: json["age"],
        gender: json["gender"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "age": age,
        "gender": gender,
      };
}
