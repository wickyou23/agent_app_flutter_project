import 'dart:math';

extension DoubleExt on double {
  double toRadian() {
    return (this * pi) / 180;
  }

  String toCSStringAsFixed(int fractionDigits) {
    var starStr = '';
    final mod = this ~/ 10;
    if (mod != 0) {
      starStr = toStringAsFixed(fractionDigits);
    } else {
      starStr = toInt().toString();
    }

    return starStr;
  }
}
