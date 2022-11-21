import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/forum_response_model/get_all_forum_category_response_model.dart';

class GetAllForumCategoryRepo extends ApiRoutes {
  Future<dynamic> getAllForumCategoryRepo() async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: getAllForumCategory);

    print('getAllCommentsResponseModel ----------- $response');

    GetAllForumCategoryResponseModel getAllForumCategoryResponseModel =
        GetAllForumCategoryResponseModel.fromJson(response);
    return getAllForumCategoryResponseModel;
  }
}
