import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/edit_profile_request_model.dart';
import 'package:tcm/model/response_model/edit_profile_response_model.dart';
import 'package:tcm/repo/edit_profile_repo.dart';

class EditProfileViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late EditProfileResponseModel response;
  Future<void> editProfileViewModel(EditProfileRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('trsp==EditProfileViewModel=>');
      response = await EditProfileRepo().editProfileRepo(model.toJson());
      print('trsp==EditProfileViewModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print(".........   $e");
    }
    update();
  }

  File? image;
  setImage(imageValue) {
    image = imageValue;
    update();
  }

  bool isUpload = false;
  setIsUpload({required bool isLoading}) {
    isUpload = isLoading;
    update();
  }
}
