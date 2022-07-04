import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/habit_tracker_model/habit_record_add_update_response_model.dart';

class HabitRecordAddUpdateRepo extends ApiRoutes {
  Future<dynamic> habitRecordAddUpdateRepo(Map<String, dynamic> body) async {
    var response = await ApiService().getResponse(
        apiType: APIType.aPost, url: habitRecordAddUpdateUrl, body: body);

    HabitRecordAddUpdateResponseModel habitRecordAddUpdateResponseModel =
        HabitRecordAddUpdateResponseModel.fromJson(response);
    return habitRecordAddUpdateResponseModel;
  }
}
