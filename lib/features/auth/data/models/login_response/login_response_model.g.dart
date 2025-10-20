// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseModelImpl(
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  isNewUser: json['isNewUser'] as bool? ?? false,
);

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{
  'user': instance.user,
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'isNewUser': instance.isNewUser,
};
