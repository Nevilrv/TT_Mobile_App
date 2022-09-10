// To parse this JSON data, do
//
//     final bodyPartsResponseModel = bodyPartsResponseModelFromJson(jsonString);

import 'dart:convert';

BodyPartsResponseModel bodyPartsResponseModelFromJson(String str) =>
    BodyPartsResponseModel.fromJson(json.decode(str));

String bodyPartsResponseModelToJson(BodyPartsResponseModel data) =>
    json.encode(data.toJson());

class BodyPartsResponseModel {
  BodyPartsResponseModel({
    this.success,
    this.msg,
    this.data,
  });

  bool? success;
  String? msg;
  List<BodyParts>? data;

  factory BodyPartsResponseModel.fromJson(Map<String, dynamic> json) =>
      BodyPartsResponseModel(
        success: json["success"],
        msg: json["msg"],
        data: List<BodyParts>.from(
            json["data"].map((x) => BodyParts.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "msg": msg,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class BodyParts {
  BodyParts({
    this.bodypartId,
    this.bodypartTitle,
    this.bodypartImage,
  });

  String? bodypartId;
  String? bodypartTitle;
  String? bodypartImage;

  factory BodyParts.fromJson(Map<String, dynamic> json) => BodyParts(
        bodypartId: json["bodypart_id"],
        bodypartTitle: json["bodypart_title"],
        bodypartImage: json["bodypart_image"],
      );

  Map<String, dynamic> toJson() => {
        "bodypart_id": bodypartId,
        "bodypart_title": bodypartTitle,
        "bodypart_image": bodypartImage,
      };
}
