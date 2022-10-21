import 'dart:math';

import 'package:agent_app/utils/constants.dart';

extension StringExt on String {
  static String randomString(int length) {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final rand = Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(
          rand.nextInt(_chars.length),
        ),
      ),
    );
  }

  bool get validatorPhoneNumber {
    if (isEmpty) {
      return false;
    }

    var valid = false;
    for (final regex in regexPhoneNumer) {
      valid = contains(RegExp(regex, multiLine: true));
      if (valid) {
        return valid;
      }
    }

    return valid;
  }

  bool get validatorE164PhoneNumber {
    if (isEmpty) {
      return false;
    }

    return contains(RegExp(regexE164PhoneNumber, multiLine: true));
  }

  String toCapitalizedCase() {
    final subStrings = split(' ');
    final buffer = StringBuffer();
    for (final item in subStrings) {
      if (item.isEmpty) {
        continue;
      }

      buffer.write(
        "${buffer.toString().isEmpty ? '' : ' '}${item.replaceRange(0, 1, item[0].toUpperCase())}",
      );
    }

    return buffer.toString();
  }

  String toFirstUpperCase() {
    if (isEmpty) return this;
    return replaceRange(0, 1, this[0].toUpperCase());
  }
}
