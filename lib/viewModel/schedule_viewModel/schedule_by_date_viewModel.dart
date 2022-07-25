import 'dart:developer';

import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/custom_packages/syncfusion_flutter_datepicker/lib/datepicker.dart';
import 'package:tcm/model/schedule_response_model/schedule_by_date_response_model.dart';
import 'package:tcm/repo/schedule_repo/schedule_by_date_repo.dart';

class ScheduleByDateViewModel extends GetxController {
  List<DateTime> dayList = [];
  DateRangePickerController dateRangePickerController =
      DateRangePickerController();

  allDates({String? date}) {}

  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  Future<void> getScheduleByDateDetails({String? userId}) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    // update();
    try {
      ScheduleByDateResponseModel response =
          await ScheduleByDateRepo().scheduleByDateRepo(userId: userId);
      log('ScheduleByDate=>$response');
      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      log("......... ScheduleByDate >$e");
      _apiResponse = ApiResponse.error(message: 'error');
    }
    update();
  }
}
