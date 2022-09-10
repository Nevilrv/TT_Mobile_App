import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/video_library_response_model/video_views_response_model.dart';
import 'package:tcm/repo/video_library_repo/video_views_repo.dart';

class VideoViewsViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');
  ApiResponse get apiResponse => _apiResponse;
  late VideoViewsResponseModel response;
  Future<void> videoViewsViewModel({String? id}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    try {
      print('trsp==RegisterResponseModel=>');
      response = await VideoViewsRepo().videoViewsRepo(id: id);
      print('trsp==RegisterResponseModel=>${response}');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print(".........   $e");
    }
    update();
  }
}
