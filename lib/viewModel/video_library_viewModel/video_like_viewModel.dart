import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/video_library_request_model/video_like_request_model.dart';
import 'package:tcm/model/response_model/video_library_response_model/video_like_response_model.dart';
import 'package:tcm/repo/video_library_repo/video_like_repo.dart';

class VideoLikeViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get apiResponse => _apiResponse;
  late VideoLikeResponseModel response;
  Future<void> videoLikeViewModel({String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      print('trsp==RegisterResponseModel=>');
      response = await VideoLikeRepo().videoLikeRepo(id: id);
      print('trsp==RegisterResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print(".........   $e");
    }
    update();
  }
}
