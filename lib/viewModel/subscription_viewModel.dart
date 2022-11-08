import 'dart:developer';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/subscription_res_model.dart';
import 'package:tcm/repo/subscription_repo.dart';

class SubscriptionViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> subscriptionDetails({String? userId}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      SubscriptionResponseModel response =
          await SubscriptionRepo().subscriptionRepo(id: userId);
      print('get details of subscription plan=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      log(".........get subscription plan >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
