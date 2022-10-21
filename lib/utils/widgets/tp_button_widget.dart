import 'package:agent_app/res/res.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum TPButtonType {
  filled,
  outline,
  linked,
  text,
}

class TPButton extends StatelessWidget {
  const TPButton({
    ValueKey? key,
    this.width = 180,
    this.height = 44,
    this.title,
    required this.onPressed,
    this.type = TPButtonType.filled,
    this.radius,
    this.wTitle,
    this.btnColor,
    this.tintColor,
  }) : super(key: key);

  factory TPButton.textButton({
    ValueKey? key,
    String? title,
    Function()? onPressed,
    Widget? wTitle,
    Color? tintColor,
    double width = 0,
  }) {
    return TPButton(
      key: key,
      width: width,
      title: title,
      onPressed: onPressed,
      type: TPButtonType.text,
      wTitle: wTitle,
      tintColor: tintColor,
    );
  }

  factory TPButton.filledButton({
    ValueKey? key,
    double width = 180,
    double height = 44,
    String? title,
    Function()? onPressed,
    double? radius,
    Widget? wTitle,
    Color? btnColor,
    Color? tintColor,
  }) {
    return TPButton(
      key: key,
      width: width,
      height: height,
      title: title,
      onPressed: onPressed,
      radius: radius,
      wTitle: wTitle,
      btnColor: btnColor,
      tintColor: tintColor,
    );
  }

  factory TPButton.deleteButton({
    ValueKey? key,
    double width = 180,
    double height = 44,
    String? title = 'Delete',
    required Function() onPressed,
    double? radius,
    Widget? wTitle,
    Color? tintColor,
  }) {
    return TPButton(
      key: key,
      width: width,
      height: height,
      title: title,
      onPressed: onPressed,
      radius: radius,
      wTitle: wTitle,
      btnColor: Colors.redAccent[100],
      tintColor: tintColor,
    );
  }

  factory TPButton.linkedButton({
    ValueKey? key,
    String? title,
    Function()? onPressed,
    Widget? wTitle,
    Color? tintColor,
    double width = 0,
  }) {
    return TPButton(
      key: key,
      width: width,
      title: title,
      onPressed: onPressed,
      type: TPButtonType.linked,
      wTitle: wTitle,
      tintColor: tintColor,
    );
  }
  final double width;
  final double height;
  final String? title;
  final TPButtonType type;
  final Function()? onPressed;
  final double? radius;
  final Widget? wTitle;
  final Color? btnColor;
  final Color? tintColor;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: width, minHeight: height),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    switch (type) {
      case TPButtonType.filled:
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: btnColor ?? AppColors.primaryColor,
            disabledForegroundColor: btnColor?.withPercentAlpha(0.5) ??
                AppColors.primaryColor.withPercentAlpha(0.5).withOpacity(0.38),
            disabledBackgroundColor: btnColor?.withPercentAlpha(0.5) ??
                AppColors.primaryColor.withPercentAlpha(0.5).withOpacity(0.12),
          ),
          onPressed: onPressed,
          child: wTitle ??
              Text(
                title!,
                style: context.theme.textTheme.body.medium.copyWith(
                  color: tintColor ?? Colors.white,
                ),
              ),
        );
      case TPButtonType.outline:
        return OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: tintColor?.withPercentAlpha(0.2) ??
                AppColors.primaryColor.withPercentAlpha(0.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius ?? height / 2),
            ),
            side: BorderSide(color: tintColor ?? AppColors.primaryColor),
          ),
          onPressed: onPressed,
          child: wTitle ??
              Text(
                title!,
                style: context.theme.textTheme.body.medium.copyWith(
                  color: tintColor ?? AppColors.primaryColor,
                ),
              ),
        );
      case TPButtonType.linked:
        return CupertinoButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          child: Text(
            title!,
            style: context.theme.textTheme.body.medium.copyWith(
              color: tintColor ?? AppColors.primaryColorDark,
              decoration: TextDecoration.underline,
            ),
          ),
        );
      case TPButtonType.text:
        return CupertinoButton(
          onPressed: onPressed,
          padding: EdgeInsets.zero,
          child: Text(
            title!,
            style: context.theme.textTheme.body.medium.copyWith(
              color: tintColor ?? AppColors.primaryColorDark,
            ),
          ),
        );
      default:
        return Container();
    }
  }
}
