import 'package:tcm/api_services/api_routes.dart';
import 'package:tcm/api_services/api_service.dart';
import 'package:tcm/model/response_model/days_model/days_model.dart';

class DayOneRepo extends ApiRoutes {
  Future<dynamic> dayOneRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: dayOneUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}

class DayTwoRepo extends ApiRoutes {
  Future<dynamic> dayTwoRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: dayTwoUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}

class DayThreeRepo extends ApiRoutes {
  Future<dynamic> dayThreeRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: dayThreeUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}

class DayFourRepo extends ApiRoutes {
  Future<dynamic> dayFourRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: dayFourUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}

class DayFiveRepo extends ApiRoutes {
  Future<dynamic> dayFiveRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: dayFiveUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}

class DaySixRepo extends ApiRoutes {
  Future<dynamic> daySixRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: daySixUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}

class DaySevenRepo extends ApiRoutes {
  Future<dynamic> daySevenRepo() async {
    var response =
        await ApiService().getResponse(apiType: APIType.aGet, url: daySevenUrl);

    DaysResponseModel daysResponseModel = DaysResponseModel.fromJson(response);
    return daysResponseModel;
  }
}
