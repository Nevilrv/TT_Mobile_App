import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/video_library_response_model/video_dislike_response_model.dart';

class VideoDislikeRepo extends ApiRoutes {
  Future<dynamic> videoDislikeRepo({String? id}) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: videoDislikeUrl, body: {"video_id": id});

    VideoDislikeResponseModel videoDislikeResponseModel =
        VideoDislikeResponseModel.fromJson(response);
    return videoDislikeResponseModel;
  }
}
