import 'package:agent_app/res/res.dart';
import 'package:flutter/material.dart';

extension ScaffoldStateExt on ScaffoldState {
  void showCSSnackBar(
    String title, {
    Duration duration = const Duration(seconds: 4),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          title,
          style: context.theme.textTheme.bodySmall?.colorWhite,
        ),
        duration: duration,
      ),
    );
  }
}
