import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/video_library_response_model/video_like_response_model.dart';

class VideoLikeRepo extends ApiRoutes {
  Future<dynamic> videoLikeRepo({String? id}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: videoLikeUrl, body: {"video_id": id});

    VideoLikeResponseModel videoLikeResponseModel =
        VideoLikeResponseModel.fromJson(response);
    return videoLikeResponseModel;
  }
}
