// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoginResponseModelImpl _$$LoginResponseModelImplFromJson(
  Map<String, dynamic> json,
) => _$LoginResponseModelImpl(
  user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
  tokens: RefreshTokenModel.fromJson(json['tokens'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$LoginResponseModelImplToJson(
  _$LoginResponseModelImpl instance,
) => <String, dynamic>{'user': instance.user, 'tokens': instance.tokens};
