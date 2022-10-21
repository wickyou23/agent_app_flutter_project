import 'dart:io';
import 'package:agent_app/res/res.dart';
import 'package:agent_app/utils/tp_logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CustomNavigationBar extends StatefulWidget {
  const CustomNavigationBar({
    Key? key,
    required this.navTitle,
    this.navTitleColor,
    this.backgroundColor = Colors.transparent,
    this.rightBarWidget,
    this.rightBarOnPressed,
    this.bgImage,
    this.backButtonOnPressed,
    this.isShowBack = true,
    this.customLeftBar,
    this.rightWidgetPadding,
  }) : super(key: key);

  static const double heightNavBar = 44;

  final String? navTitle;
  final Color? navTitleColor;
  final Color? backgroundColor;
  final Widget? rightBarWidget;
  final String? bgImage;
  final bool isShowBack;
  final Widget? customLeftBar;
  final Function()? rightBarOnPressed;
  final Function()? backButtonOnPressed;
  final EdgeInsets? rightWidgetPadding;

  @override
  State<CustomNavigationBar> createState() => _CustomNavigationBarState();
}

class _CustomNavigationBarState extends State<CustomNavigationBar> {
  int lastTap = DateTime.now().millisecondsSinceEpoch;
  int consecutiveTaps = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      width: context.media.size.width,
      height: CustomNavigationBar.heightNavBar + context.media.viewPadding.top,
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: context.media.viewPadding.top),
        constraints: const BoxConstraints(
          minHeight: CustomNavigationBar.heightNavBar,
        ),
        decoration: _getBoxDecoration(),
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        final now = DateTime.now().millisecondsSinceEpoch;
                        if (now - lastTap < 300) {
                          consecutiveTaps++;
                          if (consecutiveTaps > 6) {
                            _shareLogFile();
                            consecutiveTaps = 0;
                          }
                        } else {
                          consecutiveTaps = 0;
                        }
                        lastTap = now;
                      },
                      child: Text(
                        widget.navTitle ?? '',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style:
                            context.theme.textTheme.bodyLarge?.medium.copyWith(
                          color: widget.navTitleColor ?? AppColors.navTextColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              height: CustomNavigationBar.heightNavBar,
              child: Row(
                children: <Widget>[
                  if (widget.isShowBack)
                    CupertinoButton(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      minSize: 20,
                      child: const Icon(
                        Icons.arrow_back,
                        size: 22,
                        color: AppColors.navIconColor,
                      ),
                      onPressed: () {
                        if (widget.backButtonOnPressed != null) {
                          widget.backButtonOnPressed!();
                        } else {
                          context.navigator.pop();
                        }
                      },
                    ),
                  if (widget.customLeftBar != null) widget.customLeftBar!,
                  const Spacer(),
                  if (widget.rightBarWidget != null)
                    CupertinoButton(
                      padding: (widget.rightWidgetPadding != null)
                          ? widget.rightWidgetPadding
                          : const EdgeInsets.symmetric(horizontal: 16),
                      minSize: 20,
                      onPressed: widget.rightBarOnPressed,
                      child: widget.rightBarWidget!,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _getBoxDecoration() {
    return (widget.bgImage != null)
        ? BoxDecoration(
            image: DecorationImage(
              image: AssetImage(widget.bgImage!),
              fit: BoxFit.cover,
            ),
          )
        : BoxDecoration(
            color: widget.backgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.grey[400]!,
                blurRadius: 8.0,
              )
            ],
          );
  }

  Future<void> _shareLogFile() async {
    final box = context.findRenderObject() as RenderBox?;
    final logPath = await getLoggerPath();
    final logFile = File(logPath);
    final fileExists = await logFile.exists();
    if (!fileExists) {
      // Get.snackbar('', 'File not found', snackPosition: SnackPosition.BOTTOM);
      return;
    }

    await Share.shareFiles(
      [logPath],
      text: 'App Log',
      subject: '',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
  }
}
