import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/schedule_response_model/schedule_by_date_response_model.dart';

class ScheduleByDateRepo extends ApiRoutes {
  Future<dynamic> scheduleByDateRepo({String? userId}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: scheduleByDateUrl + userId!);

    ScheduleByDateResponseModel scheduleByDateResponseModel =
        ScheduleByDateResponseModel.fromJson(response);
    return scheduleByDateResponseModel;
  }
}
