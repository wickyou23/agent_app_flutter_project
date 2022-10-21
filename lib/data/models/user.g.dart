// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_User _$$_UserFromJson(Map<String, dynamic> json) => _$_User(
      phone: json['phone'] as String?,
      countryCode: json['countryCode'] as String?,
      accessToken: json['accessToken'] as String?,
      tokenType: json['tokenType'] as String?,
      genderString: json['genderString'] as String?,
      expiresIn: json['expiresIn'] as int?,
    );

Map<String, dynamic> _$$_UserToJson(_$_User instance) => <String, dynamic>{
      'phone': instance.phone,
      'countryCode': instance.countryCode,
      'accessToken': instance.accessToken,
      'tokenType': instance.tokenType,
      'genderString': instance.genderString,
      'expiresIn': instance.expiresIn,
    };
