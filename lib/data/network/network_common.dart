import 'dart:convert';

import 'package:agent_app/app/app_wireframe.dart';
import 'package:agent_app/data/network/network_response_object.dart';
import 'package:agent_app/data/network/network_url.dart';
import 'package:agent_app/di/dependency_injection.dart';
import 'package:agent_app/services/local_storage_service.dart';
import 'package:agent_app/utils/pretty_dio_logger.dart';
import 'package:agent_app/utils/tp_logger.dart';
import 'package:dio/dio.dart';

class NetworkCommon {
  final _decoder = const JsonDecoder();

  Dio get dio {
    final dio = Dio();

    //Set default configs
    dio.options.baseUrl = NetworkUrl.baseURL;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          logger.d(obj);
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handle) async {
          // final String currentTimeZone =
          //     await UtilsNativeChannel().getCityTimeZone();
          final user = di<LocalStoreService>().currentUser;
          final accessToken = user?.accessToken ?? '';
          if (accessToken.isEmpty == true) {
            return handle.reject(DioError(requestOptions: options));
          }

          final headers = options.headers
            ..update(
              'Authorization',
              (_) => accessToken,
              ifAbsent: () => accessToken,
            );
          options.headers = headers;
          return handle.next(options); //continue
        },
        onResponse: (response, handle) async {
          response.data = decodeRespSuccess(response);
          return handle.next(response);
        },
        onError: (e, handle) async {
          if (e.response?.statusCode == 401) {
            AppWireFrame.logout();
            return handle.next(e);
          }

          if (CancelToken.isCancel(e)) return handle.next(e);

          final repoObj = decodeRespFailed(e.response);
          e.error = repoObj.error;
          return handle.next(e);
        },
      ),
    );

    return dio;
  }

  Dio get authDio {
    final dio = Dio();

    //Set default configs
    // this.checkForCharlesProxy(dio);
    dio.options.baseUrl = NetworkUrl.baseURL;
    dio.options.connectTimeout = 10000;
    dio.options.receiveTimeout = 10000;
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        logPrint: (obj) {
          logger.d(obj);
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onError: (e, handler) {
          if (CancelToken.isCancel(e)) return handler.next(e);

          final repoObj = decodeRespFailed(e.response);
          e.error = repoObj.error;
          return handler.next(e);
        },
      ),
    );

    return dio;
  }

  NWResponseObject decodeRespSuccess(Response<dynamic> d) {
    final jsonBody = d.data;
    final statusCode = d.statusCode;

    if (statusCode == null) {
      throw Exception('Status code not found');
    }

    if (statusCode < 200 || statusCode >= 300 || jsonBody == null) {
      throw Exception('statusCode: $statusCode');
    }

    if (jsonBody is String) {
      if (jsonBody.isEmpty && statusCode == 200) {
        return NWResponseObject(
          status: statusCode,
          data: '',
          error: -1,
        );
      }

      return NWResponseObject.formJson(
        json: _decoder.convert(jsonBody) as Map<String, dynamic>,
      );
    } else {
      throw Exception('Cannot decode json');
    }
  }

  NWResponseObject decodeRespFailed(Response<dynamic>? d) {
    final jsonBody = d?.data;
    if (jsonBody is String) {
      if (jsonBody.isEmpty) throw Exception('Data not found');

      return NWResponseObject.formJson(
        json: _decoder.convert(jsonBody) as Map<String, dynamic>,
      );
    } else if (jsonBody is Map<String, dynamic>) {
      return NWResponseObject.formJson(json: jsonBody);
    } else {
      throw Exception('Cannot decode json');
    }
  }

  // void checkForCharlesProxy(Dio dio) {
  //   const charlesIp = '';
  //   if (charlesIp.isEmpty) return;
  //   appPrint('#CharlesProxyEnabled');
  //   (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
  //       (client) {
  //     client.findProxy = (uri) => "PROXY $charlesIp:8888;";
  //     client.badCertificateCallback =
  //         (X509Certificate cert, String host, int port) => true;
  //   };
  // }
}
