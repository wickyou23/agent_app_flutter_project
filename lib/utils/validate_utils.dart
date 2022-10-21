bool validateEmail(String value) {
  if (value.isEmpty) return false;
  const Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  final regex = RegExp(pattern as String);
  return regex.hasMatch(value);
}

bool validatePassword(String password) {
  return password.isNotEmpty && password.length >= 6;
}
