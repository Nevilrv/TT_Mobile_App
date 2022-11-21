import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/create_subscription_request_model.dart';
import 'package:tcm/model/response_model/create_subscription_res_model.dart';
import 'package:tcm/repo/create_subscription_repo.dart';

class CreateSubscriptionViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late CreateSubscriptionResponseModel response;
  Future<void> subscriptionViewModel(
      SubscriptionRequestModel model, String url) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('trsp==subscriptionResponseModel=>');
      response = await CreateSubscriptionRepo()
          .createSubscriptionRepo(model.toJson(), url);
      print('trsp==subscriptionResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print(".........   $e");
    }
    update();
  }
}
