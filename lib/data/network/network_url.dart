import 'package:agent_app/app/app_config.dart';
import 'package:agent_app/app/app_flavor_config.dart';

class NetworkUrl {
  static String get baseURL {
    return FlavorConfig.instance.values.apiBaseUrl;
  }

  //AUTH
  static const signinURL = '/api/mobile/auth/sendOtp';
}
