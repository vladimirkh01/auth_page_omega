import 'dart:convert';

import 'package:auth_page/network/dio_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DioRequest {
  Future logIn(String login, String password) async {
    try {
      Dio dio;
      DioSettings dioSettings;
      dioSettings = DioSettings();
      dio = dioSettings.dio;

      final jsonBody = {'login': login, 'password': password};

      final response =
          await dio.post("/api/v1/auth/login", data: jsonEncode(jsonBody));

      if (response.statusCode == 200) {
        return jsonDecode("[${response.data}]");
      } else {
        return ['GOT_ERROR'];
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }

    return;
  }
}
