import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/register_request_model.dart';
import 'package:tcm/model/response_model/register_response_model.dart';
import 'package:tcm/repo/register_repo.dart';

class RegisterViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late RegisterResponseModel response;
  Future<void> registerViewModel(RegisterRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('trsp==RegisterResponseModel=>');

      response = await RegisterRepo().registerRepo(model.toJson());
      print('===========RegisterResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print(".........aeiou  $e");
    }
    update();
  }
}
