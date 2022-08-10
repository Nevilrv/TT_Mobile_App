import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/video_library_response_model/recent_video_response_model.dart';
import 'package:tcm/model/response_model/workout_response_model/user_workouts_date_response_model.dart';
import 'package:tcm/repo/video_library_repo/recent_video_repo.dart';
import 'package:tcm/repo/workout_repo/user_workouts_date_repo.dart';

class RecentVideoViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getRecentVideoDetails({
    String? videoId,
    String? categoryId,
  }) async {
    log('videoId ==== $videoId ------ categoryId ========== $categoryId ');
    if (_apiResponse.status == Status.INITIAL) {
      _apiResponse = ApiResponse.loading(message: 'Loading');
      update();
    }

    try {
      RecentVideoResponseModel response = await RecentVideoRepo()
          .recentVideoRepo(videoId: videoId, catId: categoryId);
      print('RecentVideoResponseModel=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      print("----- RecentVideoResponseModel === >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
