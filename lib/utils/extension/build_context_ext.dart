import 'dart:math';
import 'package:agent_app/res/res.dart';
import 'package:agent_app/utils/constants.dart';
import 'package:agent_app/utils/widgets/dialogs.dart';
import 'package:agent_app/utils/widgets/tp_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension BuildContextExt on BuildContext {
  static TPLoadingDialog? _loadingDialog;

  MediaQueryData get media {
    return MediaQuery.of(this);
  }

  NavigatorState get navigator {
    return Navigator.of(this);
  }

  ModalRoute<dynamic>? get route {
    return ModalRoute.of(this);
  }

  Object? get routeArg {
    return route!.settings.arguments;
  }

  bool get isSmallDevice {
    return media.size.height < 670;
  }

  double get scaleDevice {
    return isSmallDevice ? 0.8 : 1.0;
  }

  bool get isTableDevice {
    return media.size.shortestSide > 600;
  }

  FocusScopeNode get focus {
    return FocusScope.of(this);
  }

  AppLocalizations get localization {
    return AppLocalizations.of(this)!;
  }

  ScaffoldMessengerState get scaffoldMessagerState {
    return ScaffoldMessenger.of(this);
  }

  ThemeData get theme => Theme.of(this);

  void showSnackBarMessage(String title) {
    scaffoldMessagerState
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
        ),
      );
  }

  Future<bool?> showDeleteAlert({
    String? title,
    String? message,
    String? cancelTitle,
    String? okTitle,
    VoidCallback? cancelAction,
    VoidCallback? okAction,
  }) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: this,
      builder: (ctx) {
        return AlertDialog(
          title: Container(
            height: 50,
            width: min(maxWidthForTableDevice, media.size.width),
            color: Colors.redAccent[100],
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              title ?? 'Infomation',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.popupTitleColor,
              ),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: Text(
            message ?? '',
            style: theme.textTheme.body,
          ),
          actions: <Widget>[
            TPButton.textButton(
              width: 60,
              title: cancelTitle ?? 'Cancel',
              tintColor: Colors.grey,
              onPressed: () {
                if (cancelAction != null) {
                  cancelAction();
                } else {
                  navigator.pop(false);
                }
              },
            ),
            const SizedBox(width: 8),
            TPButton.deleteButton(
              width: 0,
              onPressed: () {
                if (okAction != null) {
                  okAction();
                } else {
                  navigator.pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> showLoadingAlert({String? message}) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: this,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: AlertDialog(
            contentPadding: const EdgeInsets.only(top: 20, bottom: 16),
            titlePadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                  width: 50,
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  message!,
                  style: theme.textTheme.headline6!.copyWith(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<T?> showPopup<T>({Widget? child}) {
    return showDialog<T>(
      context: this,
      builder: (ctx) {
        return AlertDialog(
          insetPadding: const EdgeInsets.symmetric(
            vertical: 24,
          ),
          contentPadding: EdgeInsets.zero,
          titlePadding: EdgeInsets.zero,
          content: child,
          backgroundColor: Colors.transparent,
        );
      },
    );
  }

  Future<T?> showBottomSheet<T>({
    required List<T>? datas,
    required T? selectedData,
    void Function(T, int)? onSelected,
    Widget Function(BuildContext, T, int)? onCellBuild,
    String? Function(T)? onDisplay,
    bool Function(T, T?)? onCompare,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      builder: (BuildContext ctx) {
        return Container(
          height:
              min(datas!.length.toDouble() * 50, ctx.media.size.height * 0.7) +
                  media.viewPadding.bottom +
                  16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: media.viewPadding.bottom + 16),
            itemBuilder: (ctx, idx) {
              final item = datas[idx];
              return (onCellBuild != null)
                  ? onCellBuild(this, item, idx)
                  : SizedBox(
                      height: 50,
                      child: ListTile(
                        key: ValueKey(item),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        title: Text(
                          onDisplay != null ? onDisplay(item)! : item as String,
                          maxLines: 2,
                          style: ctx.theme.textTheme.body.copyWith(
                            color: Colors.black87,
                          ),
                        ),
                        trailing: (onCompare != null
                                ? onCompare(item, selectedData)
                                : (selectedData == item))
                            ? const Icon(
                                Icons.check,
                                color: AppColors.primaryColor,
                                size: 22,
                              )
                            : Container(
                                width: 1,
                              ),
                        onTap: () {
                          if (onCompare != null
                              ? onCompare(item, selectedData)
                              : (selectedData == item)) {
                            return;
                          }

                          onSelected!(item, idx);
                          navigator.pop();
                        },
                      ),
                    );
            },
            separatorBuilder: (_, idx) {
              return const Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              );
            },
            itemCount: datas.length,
          ),
        );
      },
    );
  }

  // Future<T?> showBottomSheetMultipleSelect<T>({
  //   required String title,
  //   required List<T> datas,
  //   required List<T> selectedData,
  //   Function(List<T>)? onSelected,
  //   Widget Function(BuildContext, T, int)? onCellBuild,
  //   String? Function(T)? onDisplay,
  //   bool Function(T, List<T>)? onCompare,
  // }) {
  //   return showModalBottomSheet<T>(
  //     context: this,
  //     isScrollControlled: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.only(
  //         topLeft: Radius.circular(10),
  //         topRight: Radius.circular(10),
  //       ),
  //     ),
  //     builder: (BuildContext ctx) {
  //       return Container(
  //         height:
  //             min(datas.length.toDouble() * 50, ctx.media.size.height * 0.7) +
  //                 media.viewPadding.bottom +
  //                 16,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: SelectionMultipleWidget(
  //           title: title,
  //           datas: datas,
  //           selectedData: selectedData,
  //           onSelected: onSelected,
  //           onCellBuild: onCellBuild,
  //           onDisplay: onDisplay,
  //           onCompare: onCompare,
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<bool?> showAlert({
    String? title,
    String? message,
    String? cancelTitle,
    String? okTitle,
    Color? okColor,
    Widget? customMessage,
    VoidCallback? cancelAction,
    VoidCallback? okAction,
  }) {
    return showDialog<bool>(
      barrierDismissible: false,
      context: this,
      builder: (ctx) {
        return AlertDialog(
          clipBehavior: Clip.hardEdge,
          title: Container(
            height: 50,
            width: min(maxWidthForTableDevice, media.size.width),
            color: AppColors.primaryColor,
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Text(
              title ?? 'Infomation',
              style: theme.textTheme.bodyLarge?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: AppColors.popupTitleColor,
              ),
            ),
          ),
          titlePadding: EdgeInsets.zero,
          content: customMessage ??
              Text(
                message ?? '',
                style: theme.textTheme.body,
              ),
          actions: <Widget>[
            TPButton.textButton(
              title: cancelTitle ?? 'Cancel',
              width: 60,
              tintColor: Colors.grey,
              onPressed: () {
                if (cancelAction != null) {
                  cancelAction();
                } else {
                  navigator.pop(false);
                }
              },
            ),
            const SizedBox(width: 8),
            TPButton.filledButton(
              width: 80,
              title: okTitle ?? 'OK',
              onPressed: () {
                if (okAction != null) {
                  okAction();
                } else {
                  navigator.pop(true);
                }
              },
            ),
          ],
        );
      },
    );
  }

  void showBasicAlert(
    String title,
    String message, {
    TPAlertDialogType? type,
    String? button,
    VoidCallback? onAction,
    bool barrierDismissible = true,
  }) {
    showDialog<dynamic>(
      barrierDismissible: barrierDismissible,
      context: this,
      builder: (BuildContext context) {
        return WillPopScope(
          child: TPAlertDialog(
            type: type ?? TPAlertDialogType.info,
            title: title,
            message: message,
            action: button ?? 'Close',
            onAction: onAction,
          ),
          onWillPop: () async {
            return Future<bool>.value(barrierDismissible);
          },
        );
      },
    );
  }

  void showErrorAlert(
    String title,
    String message, {
    String? button,
    VoidCallback? onAction,
    bool barrierDismissible = true,
  }) {
    showBasicAlert(
      title,
      message,
      type: TPAlertDialogType.error,
      button: button,
      onAction: onAction,
      barrierDismissible: barrierDismissible,
    );
  }

  void showSuccessAlert(
    String title,
    String message, {
    String? button,
    VoidCallback? onAction,
    bool barrierDismissible = true,
  }) {
    showBasicAlert(
      title,
      message,
      type: TPAlertDialogType.success,
      button: button,
      onAction: onAction,
      barrierDismissible: barrierDismissible,
    );
  }

  void showLoading({String? message}) {
    if (_loadingDialog == null) {
      _loadingDialog = TPLoadingDialog(message: message);
      showDialog<dynamic>(
        context: this,
        builder: (_) => WillPopScope(
          child: _loadingDialog!,
          onWillPop: () {
            return Future<bool>.value(false);
          },
        ),
        barrierDismissible: false,
      );
    }
  }

  void hideLoading() {
    if (_loadingDialog == null) return;
    navigator.pop();
    _loadingDialog = null;
  }
}
