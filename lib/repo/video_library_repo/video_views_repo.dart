import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/video_library_response_model/video_views_response_model.dart';

class VideoViewsRepo extends ApiRoutes {
  Future<dynamic> videoViewsRepo({String? id}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: videoViewsUrl, body: {"video_id": id});

    VideoViewsResponseModel videoViewsResponseModel =
        VideoViewsResponseModel.fromJson(response);
    return videoViewsResponseModel;
  }
}
