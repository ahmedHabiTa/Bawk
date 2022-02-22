import 'dart:io';
import '../error/exceptions.dart';
import 'package:dio/dio.dart';

const getNotesApi = 'notes/getall';

class ApiBaseHelper {
  final String _baseUrl = "http://192.236.155.173:55886/";
  final Dio dio = Dio();
  void dioInit() {
    dio.options.baseUrl = _baseUrl ;
    dio.options.headers = headers;
  }

  ApiBaseHelper();
  Map<String, String> headers = {
    "accept": "application/json",
    "Content-Type": 'multipart/form-data'
  };

  Future<dynamic> get({required String url, String? token}) async {
    try {
      // headers["Content-language"] = local;
      // if (token != null) {
      //   headers["Authorization"] = "Bearer " + token;
      //   dio.options.headers = headers;
      // }
      print(dio.options.baseUrl + '11111111111111');
      print("555555555555555555555555555555555$url");
      final Response response = await dio.get(url);
      final responseJson = _returnResponse(response);
      print(responseJson);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> put({
    required String url,
    String? token,
    Map<String, dynamic>? body,
  }) async {
    try {
      // headers["Content-language"] = local;
      final Response response;
      if (token != null) {
        headers["Authorization"] = "Bearer " + token;
        dio.options.headers = headers;
      }
      if (body != null) {
        FormData formData = FormData.fromMap(body);
        response = await dio.put(url, data: formData);
      } else {
        response = await dio.put(url);
      }
      final responseJson = _returnResponse(response);
      print(responseJson);
      return responseJson;
    } on SocketException {
      throw FetchDataException('No Internet connection');
    }
  }

  Future<dynamic> post(
      {required String url,
      required Map<String, dynamic> body,
      String? token}) async {
    try {
      // headers["Content-language"] = local;
      if (token != null) {
        headers["Authorization"] = "Bearer " + token;
        dio.options.headers = headers;
      }
      FormData formData = FormData.fromMap(body);
      final Response response = await dio.post(url, data: formData);
      print(response);
      final responseJson = _returnResponse(response);
      print(responseJson);
      return responseJson;
    } on DioError catch (e) {
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      print(e.response);
      print(e.message);
     // print(e.response!.headers);
     // print(e.response!.realUri);
    } on SocketException {
      throw FetchDataException('NO_INTERNET');
    }
  }

  dynamic _returnResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
        return response.data;
      case 400:
        throw BadRequestException(response.data.toString());
      case 422:
        throw response.data.toString();
      case 401:
      case 403:
        print(response.data);
        throw UnauthorizedException(message: response.data);
      case 500:
      default:
        print(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode} ${response.data}');
        throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode} ${response.data}');
    }
  }
}

class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);
  @override
  String toString() {
    return "$_prefix$_message";
  }
}

class FetchDataException extends AppException {
  FetchDataException([String? message]) : super(message, "");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}
