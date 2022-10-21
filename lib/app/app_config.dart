import 'dart:io';

import 'package:agent_app/di/dependency_injection.dart';
import 'package:agent_app/firebase_options.dart';
import 'package:agent_app/res/res.dart';
import 'package:agent_app/services/conectivity_service.dart';
import 'package:agent_app/services/local_storage_service.dart';
import 'package:agent_app/utils/tp_logger.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class AppConfig {
  static List<CameraDescription> _cameras = [];
  static List<CameraDescription> get cameras => _cameras;

  static Future<void> initConfig() async {
    setupDependencyInjection();

    final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    _cameras = await availableCameras();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode) {
      // Force disable Crashlytics collection while doing every day development.
      // Temporarily toggle this to true if you want to test crash reporting in your app.
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    await setupLogger();

    //Start service
    await di<LocalStoreService>().config();
    di<ConnectivityService>().startService();
  }

  static void setupStatusBar() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarBrightness:
            Platform.isIOS ? Brightness.dark : Brightness.light,
        statusBarIconBrightness:
            Platform.isIOS ? Brightness.dark : Brightness.light,
        systemNavigationBarColor: AppColors.primaryColor,
      ),
    );
  }
}
