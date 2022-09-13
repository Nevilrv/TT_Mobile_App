import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/update_status_user_program_request_model.dart';
import 'package:tcm/model/response_model/update_status_user_program_response_model.dart';
import 'package:tcm/repo/update_status_user_program_repo.dart';

class UpdateStatusUserProgramViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late UpdateStatusUserProgramResponseModel response;
  Future<void> updateStatusUserProgramViewModel(
      UpdateStatusUserProgramRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('trsp==UpdateStatusUserProgramResponseModel=>');
      response = await UpdateStatusUserProgramRepo()
          .updateStatusUserProgramRepo(model.toJson());
      print('trsp==UpdateStatusUserProgramResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print(".........   $e");
    }
    update();
  }
}
