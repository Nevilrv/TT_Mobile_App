// To parse this JSON data, do
//
//     final productResponseModel = productResponseModelFromJson(jsonString);

import 'dart:convert';

ProductResponseModel productResponseModelFromJson(String str) =>
    ProductResponseModel.fromJson(json.decode(str));

String productResponseModelToJson(ProductResponseModel data) =>
    json.encode(data.toJson());

class ProductResponseModel {
  ProductResponseModel({
    this.receipt,
    this.environment,
    this.latestReceiptInfo,
    this.latestReceipt,
    this.status,
  });

  Receipt? receipt;
  String? environment;
  List<LatestReceiptInfo>? latestReceiptInfo;
  String? latestReceipt;
  int? status;

  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      ProductResponseModel(
        receipt:
            json["receipt"] == null ? null : Receipt.fromJson(json["receipt"]),
        environment: json["environment"] == null ? null : json["environment"],
        latestReceiptInfo: json["latest_receipt_info"] == null
            ? null
            : List<LatestReceiptInfo>.from(json["latest_receipt_info"]
                .map((x) => LatestReceiptInfo.fromJson(x))),
        latestReceipt:
            json["latest_receipt"] == null ? null : json["latest_receipt"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "receipt": receipt == null ? null : receipt!.toJson(),
        "environment": environment == null ? null : environment,
        "latest_receipt_info": latestReceiptInfo == null
            ? null
            : List<dynamic>.from(latestReceiptInfo!.map((x) => x.toJson())),
        "latest_receipt": latestReceipt == null ? null : latestReceipt,
        "status": status == null ? null : status,
      };
}

class LatestReceiptInfo {
  LatestReceiptInfo({
    this.quantity,
    this.productId,
    this.transactionId,
    this.originalTransactionId,
    this.purchaseDate,
    this.purchaseDateMs,
    this.purchaseDatePst,
    this.originalPurchaseDate,
    this.originalPurchaseDateMs,
    this.originalPurchaseDatePst,
    this.isTrialPeriod,
    this.inAppOwnershipType,
  });

  String? quantity;
  String? productId;
  String? transactionId;
  String? originalTransactionId;
  String? purchaseDate;
  String? purchaseDateMs;
  String? purchaseDatePst;
  String? originalPurchaseDate;
  String? originalPurchaseDateMs;
  String? originalPurchaseDatePst;
  String? isTrialPeriod;
  String? inAppOwnershipType;

  factory LatestReceiptInfo.fromJson(Map<String, dynamic> json) =>
      LatestReceiptInfo(
        quantity: json["quantity"] == null ? null : json["quantity"],
        productId: json["product_id"] == null ? null : json["product_id"],
        transactionId:
            json["transaction_id"] == null ? null : json["transaction_id"],
        originalTransactionId: json["original_transaction_id"] == null
            ? null
            : json["original_transaction_id"],
        purchaseDate:
            json["purchase_date"] == null ? null : json["purchase_date"],
        purchaseDateMs:
            json["purchase_date_ms"] == null ? null : json["purchase_date_ms"],
        purchaseDatePst: json["purchase_date_pst"] == null
            ? null
            : json["purchase_date_pst"],
        originalPurchaseDate: json["original_purchase_date"] == null
            ? null
            : json["original_purchase_date"],
        originalPurchaseDateMs: json["original_purchase_date_ms"] == null
            ? null
            : json["original_purchase_date_ms"],
        originalPurchaseDatePst: json["original_purchase_date_pst"] == null
            ? null
            : json["original_purchase_date_pst"],
        isTrialPeriod:
            json["is_trial_period"] == null ? null : json["is_trial_period"],
        inAppOwnershipType: json["in_app_ownership_type"] == null
            ? null
            : json["in_app_ownership_type"],
      );

  Map<String, dynamic> toJson() => {
        "quantity": quantity == null ? null : quantity,
        "product_id": productId == null ? null : productId,
        "transaction_id": transactionId == null ? null : transactionId,
        "original_transaction_id":
            originalTransactionId == null ? null : originalTransactionId,
        "purchase_date": purchaseDate == null ? null : purchaseDate,
        "purchase_date_ms": purchaseDateMs == null ? null : purchaseDateMs,
        "purchase_date_pst": purchaseDatePst == null ? null : purchaseDatePst,
        "original_purchase_date":
            originalPurchaseDate == null ? null : originalPurchaseDate,
        "original_purchase_date_ms":
            originalPurchaseDateMs == null ? null : originalPurchaseDateMs,
        "original_purchase_date_pst":
            originalPurchaseDatePst == null ? null : originalPurchaseDatePst,
        "is_trial_period": isTrialPeriod == null ? null : isTrialPeriod,
        "in_app_ownership_type":
            inAppOwnershipType == null ? null : inAppOwnershipType,
      };
}

class Receipt {
  Receipt({
    this.receiptType,
    this.adamId,
    this.appItemId,
    this.bundleId,
    this.applicationVersion,
    this.downloadId,
    this.versionExternalIdentifier,
    this.receiptCreationDate,
    this.receiptCreationDateMs,
    this.receiptCreationDatePst,
    this.requestDate,
    this.requestDateMs,
    this.requestDatePst,
    this.originalPurchaseDate,
    this.originalPurchaseDateMs,
    this.originalPurchaseDatePst,
    this.originalApplicationVersion,
    this.inApp,
  });

  String? receiptType;
  int? adamId;
  int? appItemId;
  String? bundleId;
  String? applicationVersion;
  int? downloadId;
  int? versionExternalIdentifier;
  String? receiptCreationDate;
  String? receiptCreationDateMs;
  String? receiptCreationDatePst;
  String? requestDate;
  String? requestDateMs;
  String? requestDatePst;
  String? originalPurchaseDate;
  String? originalPurchaseDateMs;
  String? originalPurchaseDatePst;
  String? originalApplicationVersion;
  List<LatestReceiptInfo>? inApp;

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        receiptType: json["receipt_type"] == null ? null : json["receipt_type"],
        adamId: json["adam_id"] == null ? null : json["adam_id"],
        appItemId: json["app_item_id"] == null ? null : json["app_item_id"],
        bundleId: json["bundle_id"] == null ? null : json["bundle_id"],
        applicationVersion: json["application_version"] == null
            ? null
            : json["application_version"],
        downloadId: json["download_id"] == null ? null : json["download_id"],
        versionExternalIdentifier: json["version_external_identifier"] == null
            ? null
            : json["version_external_identifier"],
        receiptCreationDate: json["receipt_creation_date"] == null
            ? null
            : json["receipt_creation_date"],
        receiptCreationDateMs: json["receipt_creation_date_ms"] == null
            ? null
            : json["receipt_creation_date_ms"],
        receiptCreationDatePst: json["receipt_creation_date_pst"] == null
            ? null
            : json["receipt_creation_date_pst"],
        requestDate: json["request_date"] == null ? null : json["request_date"],
        requestDateMs:
            json["request_date_ms"] == null ? null : json["request_date_ms"],
        requestDatePst:
            json["request_date_pst"] == null ? null : json["request_date_pst"],
        originalPurchaseDate: json["original_purchase_date"] == null
            ? null
            : json["original_purchase_date"],
        originalPurchaseDateMs: json["original_purchase_date_ms"] == null
            ? null
            : json["original_purchase_date_ms"],
        originalPurchaseDatePst: json["original_purchase_date_pst"] == null
            ? null
            : json["original_purchase_date_pst"],
        originalApplicationVersion: json["original_application_version"] == null
            ? null
            : json["original_application_version"],
        inApp: json["in_app"] == null
            ? null
            : List<LatestReceiptInfo>.from(
                json["in_app"].map((x) => LatestReceiptInfo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "receipt_type": receiptType == null ? null : receiptType,
        "adam_id": adamId == null ? null : adamId,
        "app_item_id": appItemId == null ? null : appItemId,
        "bundle_id": bundleId == null ? null : bundleId,
        "application_version":
            applicationVersion == null ? null : applicationVersion,
        "download_id": downloadId == null ? null : downloadId,
        "version_external_identifier": versionExternalIdentifier == null
            ? null
            : versionExternalIdentifier,
        "receipt_creation_date":
            receiptCreationDate == null ? null : receiptCreationDate,
        "receipt_creation_date_ms":
            receiptCreationDateMs == null ? null : receiptCreationDateMs,
        "receipt_creation_date_pst":
            receiptCreationDatePst == null ? null : receiptCreationDatePst,
        "request_date": requestDate == null ? null : requestDate,
        "request_date_ms": requestDateMs == null ? null : requestDateMs,
        "request_date_pst": requestDatePst == null ? null : requestDatePst,
        "original_purchase_date":
            originalPurchaseDate == null ? null : originalPurchaseDate,
        "original_purchase_date_ms":
            originalPurchaseDateMs == null ? null : originalPurchaseDateMs,
        "original_purchase_date_pst":
            originalPurchaseDatePst == null ? null : originalPurchaseDatePst,
        "original_application_version": originalApplicationVersion == null
            ? null
            : originalApplicationVersion,
        "in_app": inApp == null
            ? null
            : List<dynamic>.from(inApp!.map((x) => x.toJson())),
      };
}
