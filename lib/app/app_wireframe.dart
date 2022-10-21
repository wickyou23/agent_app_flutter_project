import 'package:agent_app/bloc/app/app_cubit.dart';
import 'package:agent_app/bloc/app/app_state.dart';
import 'package:agent_app/views/auth/signin_screen.dart';
import 'package:agent_app/views/camera/camera_screen.dart';
import 'package:agent_app/views/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AppWireFrame {
  static const _rootName = '/';
  static final Map<String, WidgetBuilder> routes = {
    _rootName: (_) => getRootScreen(),
    CameraScreen.keyName: (_) => const CameraScreen(),
  };

  static Widget getRootScreen() {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        if (state is AppInitialState) {
          return Container();
        }

        FlutterNativeSplash.remove();
        if (state is AppReadyWithAuthenticationState) {
          return const DashboardScreen();
        }

        return const SigninScreen();
      },
    );
  }

  static void logout() {
    // FCMService().deleteInstanceID();
    // UtilsNativeChannel().cancelAllNotificationTray();
    // LocalStoreService().logout();
    // var navigatorState = GetService().navigatorKey.currentState;
    // if (navigatorState.context.route?.settings?.name == AuthScreen.routeName) {
    //   return;
    // }

    // navigatorState.pushAndRemoveUntil(
    //   PageRouteBuilder(
    //     pageBuilder: (_, __, ___) => AuthScreen(
    //       isShowSignupFirst: false,
    //       authLogout: true,
    //     ),
    //     transitionDuration: Duration(seconds: 0),
    //   ),
    //   (route) => false,
    // );
  }
}
