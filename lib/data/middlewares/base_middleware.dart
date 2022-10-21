import 'package:agent_app/data/network/network_common.dart';
import 'package:agent_app/di/dependency_injection.dart';
import 'package:agent_app/utils/tp_logger.dart';
import 'package:dio/dio.dart';

abstract class BaseMiddleware {
  final CancelToken cancelToken = CancelToken();

  Dio get dio => di<NetworkCommon>().dio;
  Dio get authDio => di<NetworkCommon>().dio;

  void close() {
    cancelToken.cancel();
    logger.i('${toString()} closed');
  }
}
