import 'dart:convert';
import 'package:get/get.dart';
import 'package:tcm/api_services/api_response.dart';
import 'package:tcm/model/request_model/habit_tracker_request_model/add_user_habit_id_request_model.dart';
import 'package:tcm/model/response_model/habit_tracker_model/add_user_habit_id_response_model.dart';
import 'package:tcm/repo/habit_tracker_repo/add_user_habit_id_repo.dart';

class AddUserHabitIdViewModel extends GetxController {
  ApiResponse _apiResponse = ApiResponse.initial(message: 'Initialization');

  ApiResponse get apiResponse => _apiResponse;
  late AddUserHabitIdResponseModel response;
  Future<void> addUserHabitIdViewModel(AddUserHabitIdRequestModel model) async {
    _apiResponse = ApiResponse.loading(message: 'Loading');
    update();
    print("model ---------- ${jsonEncode(model.toJson())}");
    try {
      print('==AddUserHabitIdViewModel=>');
      response = await AddUserHabitIdRepo().addUserHabitIdRepo(model.toJson());
      print('==AddUserHabitIdViewModel=>$response');

      _apiResponse = ApiResponse.complete(response);
    } catch (e) {
      _apiResponse = ApiResponse.error(message: e.toString());
      print("......... AddUserHabitIdViewModel ===== $e");
    }
    update();
  }
}
