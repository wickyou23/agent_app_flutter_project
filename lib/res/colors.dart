import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const primaryColor = Color(0xff081bae);
  static const primaryColorDark = Color(0xff0011a3);
  static const primaryColorLight = Color(0xff3486FE);
  static const primaryColorBlueSky = Color(0xff87cefa);

  static const darkGrey = Color(0xff25221e);

  //Button
  static const buttonIconColor = Colors.white;
  static const buttonTextColor = Colors.white;

  //Navigation
  static const navIconColor = Colors.white;
  static const navTextColor = Colors.white;

  //Popup
  static const popupTitleColor = Colors.white;

  //Another
  static const accentColor = Color(0xffED561F);
  static const tabBarBackgroundColor = Colors.white;

  static const errorColor = Color(0xFFFF2525);
  static const whiteColor = Color(0xFFFFFFFF);

  static const dartTextColor = Color(0xFF1C1C20);
  static const grayTextColor = Color(0xFF6f6f6f);

  static const hintTextColor = Color(0x806f6f6f);
  static const blackColor = Color(0xff000000);

  static const gradientBackgroundColors = [whiteColor, Color(0xff914820)];

  static final materialPrimaryColorDark =
      MaterialColor(AppColors.primaryColorDark.value, const <int, Color>{
    50: AppColors.primaryColorDark,
    100: AppColors.primaryColorDark,
    200: AppColors.primaryColorDark,
    300: AppColors.primaryColorDark,
    400: AppColors.primaryColorDark,
    500: AppColors.primaryColorDark,
    600: AppColors.primaryColorDark,
    700: AppColors.primaryColorDark,
    800: AppColors.primaryColorDark,
    900: AppColors.primaryColorDark,
  });
}
