import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/add_user_habit_id_response_model.dart';

class AddUserHabitIdRepo extends ApiRoutes {
  Future<dynamic> addUserHabitIdRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: addUserHabitIdUrl, body: body);

    AddUserHabitIdResponseModel addUserHabitIdResponseModel =
        AddUserHabitIdResponseModel.fromJson(response);
    return addUserHabitIdResponseModel;
  }
}
