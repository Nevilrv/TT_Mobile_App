import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/sign_in_request_model.dart';
import 'package:tcm/model/response_model/sign_in_response_model.dart';
import 'package:tcm/repo/sign_in_repo.dart';

class SignInViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late SignInResponseModel response;
  Future<void> signInViewModel(SignInRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('trsp==RegisterResponseModel=>');
      response = await SignInRepo().signInRepo(model.toJson());
      print('trsp==RegisterResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print(".........   $e");
    }
    update();
  }
}
