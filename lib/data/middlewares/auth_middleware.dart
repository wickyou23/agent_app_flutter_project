import 'package:agent_app/data/middlewares/base_middleware.dart';
import 'package:agent_app/data/models/user.dart';
import 'package:agent_app/data/network/network_response_state.dart';
import 'package:agent_app/data/network/network_url.dart';
import 'package:dio/dio.dart';

class AuthMiddleware extends BaseMiddleware {
  Future<ResponseState> login(String user, String password) async {
    await Future.delayed(const Duration(seconds: 5), () {});
    return ResponseSuccessState(
      statusCode: 200,
      responseData: const User(
        accessToken: 'accessToken',
      ),
    );

    try {
      final body = {
        'user': user,
        'password': password,
      };
      final res = await authDio.post(
        NetworkUrl.signinURL,
        data: body,
        cancelToken: cancelToken,
      );

      if (res.data != null) {
        return ResponseSuccessState(
          statusCode: res.statusCode ?? -1,
          responseData: const User(
            accessToken: 'accessToken',
          ),
        );
      } else {
        return ResponseFailedState(
          statusCode: -1,
          errorMessage: 'Data Error!',
          apiError: -1,
        );
      }
    } on DioError catch (e) {
      return ResponseFailedState.fromDioError(e);
    }
  }
}
