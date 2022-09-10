import 'dart:developer';
import 'dart:io';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';
import 'package:tcm/repo/video_library_repo/all_video_repo.dart';

class AllVideoViewModel extends GetxController {
  File? _thumbnail;

  File get thumbnail => _thumbnail!;

  set thumbnail(File value) {
    _thumbnail = value;
    print('thumnail>>>>>>>> $thumbnail');
    update();
  }
  // void setThumbnail(String path) {
  //   thumbnail = File(path);
  //   log('thumbnailthumbnail>>>> ${thumbnail}');
  //   update();
  // }

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;

  Future<void> getVideoDetails() async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      AllVideoResponseModel response = await AllVideoRepo().allVideoRepo();
      _apiResponse = ApiResponse.complete(response);
    } catch (error) {
      print(".....------.......----- >$error");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}

// class VideoByIdViewModel extends GetxController {
//   ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');
//
//   ApiResponse get apiResponse => _apiResponse;
//
//   Future<void> getVideoDetails({String? videoId}) async {
//     _apiResponse = ApiResponse.loading(message: 'Loading');
//     update();
//     try {
//       AllVideoResponseModel response =
//           await VideoByIdRepo().videoByIdRepo(videoId: videoId);
//       _apiResponse = ApiResponse.complete(response);
//     } catch (error) {
//       print("================= >$error");
//       _apiResponse = ApiResponse.error(message: 'error');
//     }
//     update();
//   }
// }
