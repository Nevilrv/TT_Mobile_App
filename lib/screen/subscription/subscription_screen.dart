import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:tcm/model/response_model/purchase_response_model.dart';
import 'package:tcm/model/response_model/subscription_res_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';
import 'package:tcm/viewModel/subscription_viewModel.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import '../../api_services/api_response.dart';
import '../../api_services/api_routes.dart';
import '../../model/request_model/create_subscription_request_model.dart';
import '../../utils/ColorUtils.dart';
import '../../utils/font_styles.dart';
import '../../viewModel/create_subscription_viewModel.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  _SubscriptionScreenState createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  int index = 1;
  String amount = '0';
  bool isExpired = false;
  bool isFreePlanExpired = false;
  CreateSubscriptionViewModel createSubscriptionViewModel =
      Get.put(CreateSubscriptionViewModel());
  SubscriptionViewModel subscriptionViewModel =
      Get.put(SubscriptionViewModel());
  ProductResponseModel? _productResponseModel;

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  final List<String> _productID = ['monthly_plans', 'yearly_plans'];

  bool _available = true;
  bool _loading = false;

  String discount = '';

  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];

  StreamSubscription<List<PurchaseDetails>>? _subscription;

  @override
  void initState() {
    // TODO: implement initState

    _loading = true;
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;

    try {
      _subscription = purchaseUpdated.listen(
        (purchaseDetailsList) {
          setState(() {
            _loading = true;
          });

          purchaseDetailsList.forEach((element) {
            log("purchaseDetails productID ${element.productID}");
            log("purchaseDetails purchaseID ${element.purchaseID}");
            log("purchaseDetails pendingCompletePurchase ${element.status}");
          });
          _purchases.addAll(purchaseDetailsList);
          setState(() {
            _loading = false;
          });
          log("purchaseDetails _purchases ${_purchases.last}");
          _listenToPurchaseUpdated(purchaseDetailsList);
          setState(() {
            _loading = false;
          });
        },
        onDone: () {
          setState(() {
            _loading = false;
          });
          _subscription!.cancel();
        },
        onError: (error) {
          setState(() {
            _loading = false;
          });

          _subscription!.cancel();
        },
      );
    } catch (e) {
      print("e");
    }
    _initialize();

    super.initState();
  }

  void _initialize() async {
    _available = await _inAppPurchase.isAvailable();
    print("_available $_available");
    _products = await _getProducts(
      productIds: _productID.toSet(),
    );
    int price = double.parse(_products[0].price.substring(1)).round();
    print("products $price");
    print("products ${_products[0].title}");
    // amount = _products[0].price;
    chaeckPlanIsExpired();
    setState(() {
      _products = _products;
    });
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          print('hii');

          _loading = true;

          break;
        case PurchaseStatus.purchased:
          setState(() {
            _loading = true;
          });

          var receiptBody = {
            'receipt-data':
                purchaseDetails.verificationData.localVerificationData,
            // receipt key you will receive in request purchase callback function
            'exclude-old-transactions': false,
            'password': '0fcf64fe3550478387a43843934b16a1'
          };
          print('purchased successfully');
          setState(() {
            _loading = false;
          });
          validateReceiptIos(receiptBody, true, purchaseDetails);
          break;
        case PurchaseStatus.error:
          log("purchaseD etails.error.message ${purchaseDetails.error!.message}");
          print(
              "purchaseDetails.error.message ${purchaseDetails.error!.details}");
          Get.dialog(
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text('${purchaseDetails.error!.message}'),
            ),
          );
          setState(() {
            _loading = false;
          });
          Get.back();
          break;
        default:
          break;
      }
      if (purchaseDetails.pendingCompletePurchase) {
        log('hellio....${purchaseDetails.pendingCompletePurchase}');
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    });
  }

  Future<List<ProductDetails>> _getProducts({Set<String>? productIds}) async {
    ProductDetailsResponse response =
        await _inAppPurchase.queryProductDetails(productIds!);
    setState(() {
      _loading = false;
    });
    return response.productDetails;
  }

  void _subscribe({ProductDetails? product}) {
    setState(() {
      _loading = false;
    });
    print('_loading>>>>1 ${_loading}');
    try {
      print('hello....');
      try {
        final PurchaseParam purchaseParam = PurchaseParam(
          productDetails: product!,
        );
        _inAppPurchase
            .buyNonConsumable(
              purchaseParam: purchaseParam,
            )
            .then((value) => print('value>>>  $value'));
        setState(() {
          _loading = false;
        });
      } catch (e) {
        print('eeeeee>> 1$e');
      }
    } catch (e) {
      print('eeeeee>> $e');
    }
  }

  chaeckPlanIsExpired() {
    DateTime dt1 = DateTime.now();
    DateTime dt2 =
        DateTime.parse("${PreferenceManager.isGetSubscriptionEndDate()}");
    int price = double.parse(_products[0].price.substring(1)).round();
    print("products $price");
    if (dt2.isBefore(dt1)) {
      if (PreferenceManager.isGetSubscriptionPlan() == 'free') {
        print(">>> finish free plan ");

        setState(() {
          isFreePlanExpired = true;
          index = 2;
          amount = '${_products[0].price.characters.first}$price';
          isExpired = true;
        });
      } else {
        print(">>> Plan end ");
        setState(() {
          index = 2;
          amount = '${_products[0].price.characters.first}$price';
          isExpired = true;
        });
      }
    } else if (PreferenceManager.isGetSubscriptionPlan() == 'free') {
      index = 2;
      amount = '${_products[0].price.characters.first}$price';
      isExpired = true;
    } else {
      isExpired = false;
      print(">>> Plan Continue ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorUtils.kBlack,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios_sharp,
              color: ColorUtils.kTint,
            )),
        backgroundColor: ColorUtils.kBlack,
        title: Text('Subscription', style: FontTextStyle.kWhite16BoldRoboto),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.03, vertical: Get.height * 0.02),
        child: _loading == true
            ? Center(
                child: CircularProgressIndicator(
                color: ColorUtils.kTint,
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          int price =
                              double.parse(_products[0].price.substring(1))
                                  .round();
                          print("products $price");
                          if (isExpired == true) {
                            setState(() {
                              index = 2;
                              amount =
                                  '${_products[0].price.characters.first}$price';
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: Get.height * 0.09,
                              width: Get.width * 0.9,
                              decoration: PreferenceManager
                                              .isGetSubscriptionPlan() ==
                                          'month' &&
                                      isExpired == false
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 1.0],
                                        colors:
                                            ColorUtilsGradient.kTintGradient,
                                      ),
                                      color: ColorUtils.kTint)
                                  : index == 2
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.0, 1.0],
                                            colors: ColorUtilsGradient
                                                .kTintGradient,
                                          ),
                                          color: ColorUtils.kTint)
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: ColorUtils.kTint)),
                              child: Center(
                                  child: Text(
                                '${_products[0].price.characters.first}${double.parse(_products[0].price.substring(1)).round()} / Monthly',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: PreferenceManager
                                                    .isGetSubscriptionPlan() ==
                                                'month' &&
                                            isExpired == false
                                        ? Colors.black
                                        : index == 2
                                            ? Colors.black
                                            : ColorUtils.kTint,
                                    fontSize: Get.height * 0.023),
                              )),
                            ),
                            PreferenceManager.isGetSubscriptionPlan() ==
                                        'month' &&
                                    isExpired == false
                                ? Positioned(
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorUtils.kGreen,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.03,
                                            vertical: Get.height * 0.003),
                                        child: Text(
                                          'Active',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: ColorUtils.kWhite,
                                              fontSize: Get.height * 0.016),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                      GestureDetector(
                        onTap: () {
                          int price =
                              double.parse(_products[1].price.substring(1))
                                  .round();
                          print("products $price");
                          if (isExpired == true) {
                            setState(() {
                              index = 3;
                              amount =
                                  '${_products[1].price.characters.first}$price';
                            });
                          }
                        },
                        child: Stack(
                          children: [
                            Container(
                              height: Get.height * 0.09,
                              width: Get.width * 0.9,
                              decoration: PreferenceManager
                                              .isGetSubscriptionPlan() ==
                                          'year' &&
                                      isExpired == false
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        stops: [0.0, 1.0],
                                        colors:
                                            ColorUtilsGradient.kTintGradient,
                                      ),
                                      color: ColorUtils.kTint)
                                  : index == 3
                                      ? BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            stops: [0.0, 1.0],
                                            colors: ColorUtilsGradient
                                                .kTintGradient,
                                          ),
                                          color: ColorUtils.kTint)
                                      : BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          border: Border.all(
                                              color: ColorUtils.kTint)),
                              child: Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: Get.height * 0.009,
                                  ),
                                  Text(
                                    '${_products[1].price.characters.first}${double.parse(_products[1].price.substring(1)).round()} / Yearly',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: PreferenceManager
                                                        .isGetSubscriptionPlan() ==
                                                    'year' &&
                                                isExpired == false
                                            ? Colors.black
                                            : index == 3
                                                ? Colors.black
                                                : ColorUtils.kTint,
                                        fontSize: Get.height * 0.023),
                                  ),
                                  Text(
                                    'Save ${_products[0].price.characters.first}${double.parse(_products[0].price.substring(1)).round() * 12 - double.parse(_products[1].price.substring(1)).round()} a year',
                                    style: TextStyle(
                                        color: PreferenceManager
                                                        .isGetSubscriptionPlan() ==
                                                    'year' &&
                                                isExpired == false
                                            ? Colors.black
                                            : index == 3
                                                ? Colors.black
                                                : ColorUtils.kTint,
                                        fontSize: Get.height * 0.015),
                                  ),
                                ],
                              )),
                            ),
                            PreferenceManager.isGetSubscriptionPlan() ==
                                        'year' &&
                                    isExpired == false
                                ? Positioned(
                                    right: 0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: ColorUtils.kGreen,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomLeft: Radius.circular(6))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: Get.width * 0.03,
                                            vertical: Get.height * 0.003),
                                        child: Text(
                                          'Active',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: ColorUtils.kWhite,
                                              fontSize: Get.height * 0.016),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: Get.height * 0.03,
                      ),
                    ],
                  ),
                  PreferenceManager.isGetSubscriptionPlan() == 'free'
                      ? isFreePlanExpired == true
                          ? Center(
                              child: Text(
                                "Please purchase new plan ",
                                style: FontTextStyle.kWhite16BoldRoboto
                                    .copyWith(
                                        fontSize: Get.height * 0.018,
                                        fontWeight: FontWeight.w400),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Free Plan - ",
                                  style: FontTextStyle.kWhite16BoldRoboto,
                                ),
                                Text(
                                  "${DateTime.parse(PreferenceManager.isGetSubscriptionEndDate()).difference(DateTime.now()).inDays} Day Left",
                                  style: FontTextStyle.kWhite16BoldRoboto
                                      .copyWith(
                                          fontSize: Get.height * 0.018,
                                          fontWeight: FontWeight.w400),
                                ),
                              ],
                            )
                      : isExpired == true
                          ? Center(
                              child: Text(
                                "Please purchase new plan ",
                                style: FontTextStyle.kWhite16BoldRoboto
                                    .copyWith(
                                        fontSize: Get.height * 0.018,
                                        fontWeight: FontWeight.w400),
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Your plan will be expired on ${DateFormat('dd, M MM yyyy').format(DateTime.parse(PreferenceManager.isGetSubscriptionEndDate()))} ",
                                  style: FontTextStyle.kWhite16BoldRoboto
                                      .copyWith(
                                          fontSize: Get.height * 0.018,
                                          fontWeight: FontWeight.w400),
                                ),
                              ],
                            ),
                  Spacer(),
                  isExpired == true
                      ? Column(
                          children: [
                            Divider(
                              color: ColorUtils.kTint,
                              thickness: 1,
                            ),
                            SizedBox(
                              height: Get.height * 0.01,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: Get.width * 0.05,
                                ),
                                Text(
                                  '${amount}',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: ColorUtils.kWhite,
                                      fontSize: Get.height * 0.025),
                                ),
                                Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _loading = true;
                                    });
                                    if (index == 2) {
                                      _subscribe(product: _products[0]);
                                    } else {
                                      _subscribe(product: _products[1]);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: ColorUtils.kTint,
                                        borderRadius: BorderRadius.circular(6)),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Get.height * 0.01,
                                          horizontal: Get.width * 0.1),
                                      child: Text(
                                        'Pay',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: ColorUtils.kBlack,
                                            fontSize: Get.height * 0.018),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: Get.width * 0.05,
                                ),
                              ],
                            )
                          ],
                        )
                      : SizedBox(),
                  SizedBox(
                    height: Get.height * 0.02,
                  ),
                ],
              ),
      ),
    );
  }

  Future<http.Response> validateReceiptIos(
      receiptBody, isTest, PurchaseDetails purchaseDetails) async {
    print('it called');
    setState(() {
      _loading = true;
    });
    // final String url = isTest
    //     ? 'https://sandbox.itunes.apple.com/verifyReceipt'
    //     : 'https://buy.itunes.apple.com/verifyReceipt';
    http.Response response = await http.post(
      Uri.parse('https://sandbox.itunes.apple.com/verifyReceipt'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
      body: json.encode(receiptBody),
    );
    if (response.statusCode == 200) {
      // var receipt = purchaseDetails.verificationData.serverVerificationData;
      // log('response${response.body}');
      log('response${response.body}');
      _inAppPurchase.completePurchase(purchaseDetails);

      log('RESPONSE ${response.statusCode}');
      _productResponseModel = productResponseModelFromJson(response.body);
      if (_productResponseModel!.status == 0) {
        print(
            'NewPurchase${_productResponseModel!.receipt!.inApp![0].productId}');

        if (_productResponseModel!.receipt!.inApp![0].productId ==
            'monthly_plans') {
          print('MONTHLY PLANS');
          print(
              'expire plan date >>> ${Jiffy().add(months: 1).dateTime.toString()}');
          SubscriptionRequestModel model = SubscriptionRequestModel();
          model.userId = PreferenceManager.getUId();
          model.startDate = Jiffy().dateTime.toString();
          model.endDate = Jiffy().add(months: 1).dateTime.toString();
          model.currentPlan = 'month';
          await createSubscriptionViewModel
              .subscriptionViewModel(model, ApiRoutes().updateSubscriptionUrl)
              .whenComplete(() {
            getSubscriptionDetails();
            // Get.to(HomeScreen());
            Get.back();
          });
          setState(() {
            _loading = false;
          });
          print('MONTHLY PLANS');
        } else if (_productResponseModel!.receipt!.inApp![0].productId ==
            'yearly_plans') {
          print('YEARLY PLANS');
          print(
              'expire plan date >>> ${Jiffy().add(months: 12).dateTime.toString()}');
          SubscriptionRequestModel model = SubscriptionRequestModel();
          model.userId = PreferenceManager.getUId();
          model.startDate = Jiffy().dateTime.toString();
          model.endDate = Jiffy().add(months: 12).dateTime.toString();
          model.currentPlan = 'year';
          await createSubscriptionViewModel
              .subscriptionViewModel(model, ApiRoutes().updateSubscriptionUrl)
              .whenComplete(() {
            getSubscriptionDetails();
            // Get.to(HomeScreen());
            Get.back();
          });
          setState(() {
            _loading = false;
          });
        } else {
          print(
              'NewPurchase${_productResponseModel!.receipt!.inApp![0].productId}');
        }
      }
    } else {
      print('STATUS CODE--${response.statusCode}');
    }
    return response;
  }

  getSubscriptionDetails() async {
    await subscriptionViewModel.subscriptionDetails(
        userId: PreferenceManager.getUId());
    if (subscriptionViewModel.apiResponse.status == Status.COMPLETE) {
      SubscriptionResponseModel responseModel =
          subscriptionViewModel.apiResponse.data;
      print('subscription details >>>>>> $responseModel');
      PreferenceManager.isSetSubscriptionStartDate(
          responseModel.data!.startDate.toString());
      PreferenceManager.isSetSubscriptionEndDate(
          responseModel.data!.endDate.toString());
      PreferenceManager.isSetSubscriptionPlan(
          responseModel.data!.currentPlan.toString());
      DateTime dt1 = DateTime.now();
      DateTime dt2 = DateTime.parse("${responseModel.data!.endDate}");

      if (dt2.isBefore(dt1)) {
        print(">>> Plan end ");
      } else {
        print(">>> Plan Continue ");
      }
    }
  }
}
