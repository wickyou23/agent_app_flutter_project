import 'package:flutter/material.dart';

extension MediaQueryDataExt on MediaQueryData {
  double get contentHeight {
    return size.height - padding.top;
  }
}
