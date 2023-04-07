import 'package:dio/dio.dart' as dio;
import 'package:shared_preferences/shared_preferences.dart';

import 'header.dart';

class APIClient {
  dio.Dio dioClient = dio.Dio();
  var token = '';

  getLocalToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tokenString = prefs.getString("token");
    if (tokenString != null) {
      token = tokenString;
    }
  }

  _getHeaders({Map options = const {}}) async {
    final headers = await HeaderHandler().getHeaders();

    Map<String, String> allHeaders = {
      // "authorization": "Bearer $token",
      // ...options,
      // ...headers,
    };
    return allHeaders;
  }

  Future getData({
    required String url,
    Map headers = const {},
  }) async {
    await getLocalToken();
    try {
      var response = await dioClient.get(
        url,
      );

      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future postData({
    required String url,
    required dynamic data,
    Map headers = const {},
  }) async {
    await getLocalToken();

    try {
      dio.Response response = await dioClient.post(
        url,
        data: data,
      );
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future putData({
    required String url,
    required dynamic data,
  }) async {
    await getLocalToken();
    try {
      var response = await dioClient.put(
        url,
        data: data,
        options: dio.Options(
          headers: await _getHeaders(),
          responseType: dio.ResponseType.json,
        ),
      );
      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }

  Future deleteData({
    required String url,
  }) async {
    await getLocalToken();
    try {
      var response = dioClient.delete(
        url,
        options: dio.Options(
          headers: await _getHeaders(),
          responseType: dio.ResponseType.json,
        ),
      );
      HeaderHandler().handleHeaders(response);
      return response;
    } on dio.DioError catch (error) {
      HeaderHandler().handleHeaders(error.response!);
      rethrow;
    } catch (error) {
      rethrow;
    }
  }
}
