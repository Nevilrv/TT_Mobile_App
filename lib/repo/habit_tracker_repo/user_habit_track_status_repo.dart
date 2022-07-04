import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/custom_habit_response_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/user_habit_tracker_status_response_model.dart';

class UserHabitTrackStatusRepo extends ApiRoutes {
  Future<dynamic> userHabitTrackStatusRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: userHabitTrackUrl, body: body);

    UserHabitTrackStatusResponseModel userHabitTrackStatusResponseModel =
        UserHabitTrackStatusResponseModel.fromJson(response);
    return userHabitTrackStatusResponseModel;
  }
}
