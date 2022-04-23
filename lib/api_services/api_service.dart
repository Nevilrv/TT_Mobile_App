import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum APIType { aGet, aPost }

class ApiService {
  var respose;
  Future<dynamic> getResponse({
    required APIType apiType,
    required String url,
    Map<String, dynamic>? body,
  }) async {
    Map<String, String> headers = {
      "Host": "<calculated when request is sent>",
      "User-Agent": "PostmanRuntime/7.29.0",
      "Accept": "*/*",
      "Accept-Encoding": "gzip, deflate, br",
      "Connection": "keep-alive"
    };

    try {
      if (apiType == APIType.aGet) {
        final result = await http.get(Uri.parse(url));
        respose = returnResponse(result.statusCode, result.body);
        print("REQUEST PARAMETER url  $url");
      } else if (apiType == APIType.aPost) {
        final result =
            await http.post(Uri.parse(url), body: body, headers: headers);

        log("resp${result.body}");

        respose = returnResponse(result.statusCode, result.body);
        print(result.statusCode);
      }
    } catch (error) {
      return print(error);
    }
    return respose;
  }

  returnResponse(int status, String result) {
    switch (status) {
      case 200:
        return jsonDecode(result);
      case 201:
        return jsonDecode(result);
      case 400:
        return jsonDecode(result);
      // throw BadRequestException('Bad Request');
      //   case 401:
      //     return Get.offAll(AskForLogin());
      //   case 403:
      //     return Get.offAll(AskForLogin());
      // case 404:
      // throw ServerException('Server Error');
      case 500:
      default:
      // throw FetchDataException('Internal Server Error');
    }
  }
}
