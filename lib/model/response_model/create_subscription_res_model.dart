// To parse this JSON data, do
//
//     final createSubscriptionResponseModel = createSubscriptionResponseModelFromJson(jsonString);

import 'dart:convert';

CreateSubscriptionResponseModel createSubscriptionResponseModelFromJson(
        String str) =>
    CreateSubscriptionResponseModel.fromJson(json.decode(str));

String createSubscriptionResponseModelToJson(
        CreateSubscriptionResponseModel data) =>
    json.encode(data.toJson());

class CreateSubscriptionResponseModel {
  CreateSubscriptionResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<dynamic>? data;

  factory CreateSubscriptionResponseModel.fromJson(Map<String, dynamic> json) =>
      CreateSubscriptionResponseModel(
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
