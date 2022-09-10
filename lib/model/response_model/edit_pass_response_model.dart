// To parse this JSON data, do
//
//     final editPassResponseModel = editPassResponseModelFromJson(jsonString);

import 'dart:convert';

EditPassResponseModel editPassResponseModelFromJson(String str) =>
    EditPassResponseModel.fromJson(json.decode(str));

String editPassResponseModelToJson(EditPassResponseModel data) =>
    json.encode(data.toJson());

class EditPassResponseModel {
  EditPassResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory EditPassResponseModel.fromJson(Map<String, dynamic> json) =>
      EditPassResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x)),
      };
}
