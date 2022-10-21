import 'package:agent_app/res/res.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData createTheme() {
  final textTheme = createTextTheme();
  return ThemeData(
    primarySwatch: AppColors.materialPrimaryColorDark,
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
        ),
    backgroundColor: AppColors.whiteColor,
    scaffoldBackgroundColor: AppColors.whiteColor,
    hintColor: AppColors.hintTextColor,
    dividerColor: Colors.grey,
    textTheme: textTheme,
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primaryColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(Colors.black87),
        backgroundColor:
            MaterialStateProperty.all<Color>(AppColors.primaryColor),
        overlayColor: MaterialStateProperty.all<Color>(
          Colors.white.withPercentAlpha(0.2),
        ),
      ),
    ),
    appBarTheme: const AppBarTheme(
      color: AppColors.primaryColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
