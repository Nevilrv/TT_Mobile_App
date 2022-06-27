import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/training_plans_response_model/workout_exercise_conflict_response_model.dart';

class WorkoutExerciseConflictRepo extends ApiRoutes {
  Future<dynamic> workoutExerciseConflictRepo({String? date}) async {
    var response = await ApiService()
        .getResponse(apiType: APIType.aGet, url: workoutByFilterUrl + date!);

    WorkoutExerciseConflictResponseModel workoutExerciseConflictResponseModel =
        WorkoutExerciseConflictResponseModel.fromJson(response);
    return workoutExerciseConflictResponseModel;
  }
}
