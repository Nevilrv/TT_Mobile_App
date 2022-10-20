import 'dart:developer';

import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/exercise_by_id_response_model.dart';
import 'package:tcm/preference_manager/preference_store.dart';

class ExerciseByIdRepo extends ApiRoutes {
  Future<ExerciseByIdResponseModel> exerciseByIdRepo({String? id}) async {
    log('res of by id c   $id');

    var response = await ApiService().getResponse(
        apiType: APIType.aGet,
        url: exerciseByIdUrl +
            id! +
            "&user_id=" +
            '${PreferenceManager.getUId()}');
    log('res of by id $response');
    ExerciseByIdResponseModel exerciseByIdResponseModel =
        ExerciseByIdResponseModel.fromJson(response);
    return exerciseByIdResponseModel;
  }
}
