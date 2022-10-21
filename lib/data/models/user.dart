import 'package:agent_app/data/converter/date_time_converter.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
@DateTimeConverter()
class User with _$User {
  const factory User({
    final String? phone,
    final String? countryCode,
    final String? accessToken,
    final String? tokenType,
    final String? genderString,
    final int? expiresIn,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
