// To parse this JSON data, do
//
//     final subscriptionResponseModel = subscriptionResponseModelFromJson(jsonString);

import 'dart:convert';

SubscriptionResponseModel subscriptionResponseModelFromJson(String str) =>
    SubscriptionResponseModel.fromJson(json.decode(str));

String subscriptionResponseModelToJson(SubscriptionResponseModel data) =>
    json.encode(data.toJson());

class SubscriptionResponseModel {
  SubscriptionResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  Data? data;

  factory SubscriptionResponseModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionResponseModel(
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
    this.subscriptionId,
    this.userId,
    this.startDate,
    this.endDate,
    this.currentPlan,
  });

  String? subscriptionId;
  String? userId;
  DateTime? startDate;
  DateTime? endDate;
  String? currentPlan;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        subscriptionId: json["subscription_id"],
        userId: json["user_id"],
        startDate: DateTime.parse(json["start_date"]),
        endDate: DateTime.parse(json["end_date"]),
        currentPlan: json["current_plan"],
      );

  Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "user_id": userId,
        "start_date":
            "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
        "end_date":
            "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
        "current_plan": currentPlan,
      };
}
