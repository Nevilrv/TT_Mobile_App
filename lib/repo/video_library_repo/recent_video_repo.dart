import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/video_library_response_model/recent_video_response_model.dart';

class RecentVideoRepo extends ApiRoutes {
  Future<dynamic> recentVideoRepo({String? videoId, String? catId}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aGet,
        url: recentVideoUrl + videoId! + "&category_id=" + catId!);

    print('response?>>>>>>>  ${response}');

    RecentVideoResponseModel recentVideoResponseModel =
        RecentVideoResponseModel.fromJson(response);
    return recentVideoResponseModel;
  }
}
