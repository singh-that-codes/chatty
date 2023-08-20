// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:chatty/common/utils/loading.dart';
import 'package:chatty/common/values/cache.dart';
import 'package:chatty/common/values/server.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:chatty/common/store/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart' hide FormData;

class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();
  factory HttpUtil() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  Future<dynamic> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );

    return response.data;
  }

  HttpUtil._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: SERVER_API_URL,
      connectTimeout: Duration(milliseconds: 10000),
      receiveTimeout: Duration(milliseconds: 5000),
      headers: {},
      contentType: 'application/json; charset=utf-8',
      responseType: ResponseType.json,
    );

    dio = Dio(options);

    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    CookieJar cookieJar = CookieJar();
    dio.interceptors.add(CookieManager(cookieJar));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (DioError e, handler) {
        Loading.dismiss();
        ErrorEntity eInfo = createErrorEntity(e);
        onError(eInfo);
        return handler.next(e);
      },
    ));
  }

  void onError(ErrorEntity eInfo) {
    print('error.code -> ' +
        eInfo.code.toString() +
        ', error.message -> ' +
        eInfo.message);
    if (eInfo.code == 401) {
      UserStore.to.onLogout();
      EasyLoading.showError(eInfo.message);
    } else {
      EasyLoading.showError('Unknown error');
    }
  }

  ErrorEntity createErrorEntity(DioError error) {
    if (error.type == DioErrorType.cancel) {
      return ErrorEntity(code: -1, message: "Request canceled");
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return ErrorEntity(code: -1, message: "Connection timeout");
    } else if (error.type == DioErrorType.sendTimeout) {
      return ErrorEntity(code: -1, message: "Request timeout");
    } else if (error.type == DioErrorType.receiveTimeout) {
      return ErrorEntity(code: -1, message: "Response timeout");
    } else if (error.type == DioExceptionType.badResponse) {
      try {
        int errCode = error.response != null ? error.response!.statusCode! : -1;
        if (errCode == 400) {
          return ErrorEntity(code: errCode, message: "Request syntax error");
        } else if (errCode == 401) {
          return ErrorEntity(code: errCode, message: "Unauthorized");
        } else if (errCode == 403) {
          return ErrorEntity(code: errCode, message: "Server refused to execute");
        } else if (errCode == 404) {
          return ErrorEntity(code: errCode, message: "Cannot connect to server");
        } else if (errCode == 405) {
          return ErrorEntity(code: errCode, message: "Request method not allowed");
        } else if (errCode == 500) {
          return ErrorEntity(code: errCode, message: "Internal server error");
        } else if (errCode == 502) {
          return ErrorEntity(code: errCode, message: "Invalid request");
        } else if (errCode == 503) {
          return ErrorEntity(code: errCode, message: "Server is down");
        } else if (errCode == 505) {
          return ErrorEntity(code: errCode, message: "HTTP protocol request not supported");
        } else {
          return ErrorEntity(
            code: errCode,
            message: error.response != null ? error.response!.statusMessage! : "",
          );
        }
      } on Exception catch (_) {
        return ErrorEntity(code: -1, message: "Unknown error");
      }
    } else {
      return ErrorEntity(
        code: -1, 
        message: error.message ?? "Unknown error");
    }
  }

  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  Map<String, dynamic>? getAuthorizationHeader() {
    var headers = <String, dynamic>{};
    if (Get.isRegistered<UserStore>() && UserStore.to.hasToken == true) {
      headers['Authorization'] = 'Bearer ${UserStore.to.token}';
    }
    return headers;
  }

  Future<dynamic> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = !CACHE_ENABLE,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    if (requestOptions.extra == null) {
      requestOptions.extra = Map();
    }
    requestOptions.extra!.addAll({
      "refresh": refresh,
      "noCache": noCache,
      "list": list,
      "cacheKey": cacheKey,
      "cacheDisk": cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = getAuthorizationHeader();
    if (authorization != null) {
      requestOptions.headers!.addAll(authorization);
    }

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  // ... Similar changes for other methods like post, put, patch, delete, postForm, postStream ...
}

class ErrorEntity implements Exception {
  int code = -1;
  String message = "";
  ErrorEntity({required this.code, required this.message});

  String toString() {
    if (message == "") return "Exception";
    return "Exception: code $code, $message";
  }
}
