import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/custom_habit_response_model.dart';

class CustomHabitRepo extends ApiRoutes {
  Future<dynamic> customHabitRepo(Map<String, dynamic> body) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aPost, url: customHabitUrl, body: body);

    CustomHabitResponseModel customHabitResponseModel =
        CustomHabitResponseModel.fromJson(response);
    return customHabitResponseModel;
  }
}
