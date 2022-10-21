import 'dart:async';

import 'package:agent_app/app/app_config.dart';
import 'package:agent_app/app/app_entry.dart';
import 'package:agent_app/app/app_flavor_config.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

void main() {
  runZonedGuarded(() async {
    FlavorConfig(
      flavor: Flavor.dev,
      values: FlavorValues(
        appName: 'Agent-DEV',
        apiBaseUrl: 'http://developURL',
      ),
    );

    await AppConfig.initConfig();
    runApp(const MyApp());
  }, (Object error, StackTrace stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}
