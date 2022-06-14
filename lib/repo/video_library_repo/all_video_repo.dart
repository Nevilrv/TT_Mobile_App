import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/video_library_response_model/all_video_res_model.dart';

class AllVideoRepo extends ApiService {
  Future<dynamic> allVideoRepo({String? videoId}) async {
    print('url video ==== ${ApiRoutes.getVideoes}');

    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: ApiRoutes.getVideoes);

    AllVideoResponseModel allVideoResponseModel =
        AllVideoResponseModel.fromJson(response);
    return allVideoResponseModel;
  }
}

// class VideoByIdRepo extends ApiService {
//   Future<dynamic> videoByIdRepo({String? videoId}) async {
//     print('url video ==== ${ApiRoutes.getVideoes}');
//
//     var response = await ApiService().getResponse(
//         apiType: APIType.aGet,
//         url: ApiRoutes.getVideoes + videoId! + "&category_id=");
//
//     AllVideoResponseModel allVideoResponseModel =
//         AllVideoResponseModel.fromJson(response);
//     return allVideoResponseModel;
//   }
// }
