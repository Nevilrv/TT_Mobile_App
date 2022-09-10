import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/edit_pass_request_model.dart';
import 'package:tcm/model/response_model/edit_pass_response_model.dart';
import 'package:tcm/repo/edit_pass_repo.dart';

class EditPassViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late EditPassResponseModel response;
  Future<void> editPassViewModel(EditPassRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('trsp==RegisterResponseModel=>');
      response = await EditPassRepo().editPassRepo(model.toJson());
      print('trsp==RegisterResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print(".........   $e");
    }
    update();
  }
}
