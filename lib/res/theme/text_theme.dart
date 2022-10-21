import 'package:agent_app/res/res.dart';
import 'package:flutter/material.dart';

const fontFamily = 'Roboto';

class TextSizes {
  static const bodyLarge = 18.0;
  static const body = 16.0;
  static const bodySmall = 14.0;
  static const bodySmall2 = 12.0;
  static const headerline = 20.0;
}

extension TextThemeExt on TextTheme {
  TextStyle get body => bodyText1!.copyWith(fontSize: TextSizes.body);
  TextStyle get bodySmall => bodyText1!.copyWith(fontSize: TextSizes.bodySmall);
  TextStyle get bodySmall2 =>
      bodyText1!.copyWith(fontSize: TextSizes.bodySmall2);
  TextStyle get bodyLarge => bodyText1!.copyWith(fontSize: TextSizes.bodyLarge);
  TextStyle get headerline =>
      bodyText1!.copyWith(fontSize: TextSizes.headerline);
}

extension TextStyleExt on TextStyle {
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get medium => copyWith(fontWeight: FontWeight.w600);

  TextStyle get light => copyWith(fontWeight: FontWeight.w300);

  // colors
  TextStyle get colorPrimary => copyWith(color: AppColors.primaryColor);

  TextStyle get colorAccent => copyWith(color: AppColors.accentColor);

  TextStyle get colorDart => copyWith(color: AppColors.dartTextColor);

  TextStyle get colorGray => copyWith(color: AppColors.grayTextColor);

  TextStyle get colorWhite => copyWith(color: AppColors.whiteColor);
}

TextTheme createTextTheme() => const TextTheme(
      bodyText1: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.normal,
        fontSize: TextSizes.bodyLarge,
        color: Colors.black87,
      ),
    );

TextTheme createPrimaryTextTheme() =>
    createTextTheme().apply(bodyColor: AppColors.whiteColor);

TextTheme createAccentTextTheme() =>
    createTextTheme().apply(bodyColor: AppColors.whiteColor);

TextTheme textTheme(BuildContext context) {
  return Theme.of(context).textTheme;
}

TextTheme primaryTextTheme(BuildContext context) {
  return Theme.of(context).primaryTextTheme;
}
