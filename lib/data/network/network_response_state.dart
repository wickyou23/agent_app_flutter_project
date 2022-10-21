import 'package:dio/dio.dart';

abstract class ResponseState {
  ResponseState({required this.statusCode});
  final int statusCode;
}

class ResponseSuccessState<T> extends ResponseState {
  ResponseSuccessState({required super.statusCode, required this.responseData});

  final T responseData;

  ResponseSuccessState<T> copyWith({
    required int statusCode,
    required T responseData,
  }) {
    return ResponseSuccessState<T>(
      statusCode: statusCode,
      responseData: responseData ?? this.responseData,
    );
  }
}

class ResponseFailedState extends ResponseState {
  factory ResponseFailedState.fromDioError(DioError e) {
    // var dataError = e.error;
    // if (dataError is NWErrorEnum) {
    //   return ResponseFailedState(
    //     statusCode: e.response.statusCode,
    //     errorMessage: dataError.errorMessage,
    //     apiError: dataError,
    //   );
    // } else if (dataError is SocketException) {
    //   var osError = dataError.osError;
    //   if (osError.errorCode == 101 || osError.errorCode == 51) {
    //     return ResponseFailedState(
    //       statusCode: osError.errorCode,
    //       errorMessage: osError.message,
    //     );
    //   }
    // }

    return ResponseFailedState(
      statusCode: e.response?.statusCode ?? -1,
      errorMessage: 'An error occurred. Please try again.',
      apiError: -1,
    );
  }

  ResponseFailedState({
    required super.statusCode,
    required this.errorMessage,
    required this.apiError,
  });

  final int apiError;
  final String errorMessage;
}
