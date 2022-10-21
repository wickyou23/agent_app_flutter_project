import 'package:agent_app/res/res.dart';
import 'package:agent_app/utils/widgets/tp_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum TPAlertDialogType { info, warning, error, success }

extension TPAlertDialogTypeExt on TPAlertDialogType {
  Color get color {
    switch (this) {
      case TPAlertDialogType.error:
        return Colors.redAccent;
      case TPAlertDialogType.warning:
        return Colors.yellow[700]!;
      case TPAlertDialogType.success:
        return Colors.green;
      default:
        return Colors.black87;
    }
  }
}

class TPLoadingDialog extends StatelessWidget {
  const TPLoadingDialog({Key? key, this.message}) : super(key: key);

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (message == null)
          ? _buildLoadingWidgetNoMessage()
          : _buildLoadingWidgetMessage(context),
    );
  }

  Widget _buildLoadingWidgetNoMessage() {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: const SpinKitPulse(color: AppColors.primaryColor),
    );
  }

  Widget _buildLoadingWidgetMessage(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const SpinKitPulse(color: AppColors.primaryColor),
              const SizedBox(width: 20),
              Flexible(
                child: Text(
                  message ?? '',
                  style: context.theme.textTheme.body,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TPAlertDialog extends StatelessWidget {
  const TPAlertDialog({
    Key? key,
    this.type = TPAlertDialogType.info,
    this.title,
    this.message,
    this.action,
    this.onAction,
  }) : super(key: key);

  final TPAlertDialogType type;
  final String? title;
  final String? message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? Text(
              title!,
              style: context.theme.textTheme.bodyLarge?.medium
                  .copyWith(color: type.color),
            )
          : null,
      content: Text(
        message!,
        style: context.theme.textTheme.body,
      ),
      actions: <Widget>[
        TPButton.filledButton(
          title: action,
          onPressed: () {
            onAction?.call();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

class ImageDialog extends StatelessWidget {
  const ImageDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    this.imageUrl,
    this.onAction,
    this.titleColor,
  }) : super(key: key);

  final String title;
  final String description;
  final String buttonText;
  final VoidCallback? onAction;
  final String? imageUrl;
  final Color? titleColor;

  static const double padding = 16;
  static const double avatarRadius = 66;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }

  Widget dialogContent(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
            top: avatarRadius + padding,
            bottom: padding,
            left: padding,
            right: padding,
          ),
          margin: const EdgeInsets.only(top: avatarRadius),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(padding),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // To make the card compact
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: titleColor ?? Colors.black54,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.bottomRight,
                child: TPButton.filledButton(
                  onPressed: () {
                    onAction?.call();
                    Navigator.of(context).pop(); // To close the dialog
                  },
                  title: buttonText,
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.topCenter,
            child: CircleAvatar(
              backgroundImage: NetworkImage(imageUrl!),
              backgroundColor: Colors.cyan,
              radius: avatarRadius,
            ),
          ),
        ),
      ],
    );
  }
}
