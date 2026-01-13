// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['_id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      dateOfBirth: json['dateOfBirth'] as String?,
      gender: json['gender'] as String?,
      bio: json['bio'] as String?,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => PhotoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      interestedIn: json['interestedIn'] as String?,
      studentId: json['studentId'] as String?,
      major: json['major'] as String?,
      className: json['class'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      isProfileComplete: json['isProfileComplete'] as bool? ?? false,
      lastActive: json['lastActive'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      approvalStatus: json['approvalStatus'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      approvedAt: json['approvedAt'] as String?,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'bio': instance.bio,
      'photos': instance.photos,
      'interests': instance.interests,
      'interestedIn': instance.interestedIn,
      'studentId': instance.studentId,
      'major': instance.major,
      'class': instance.className,
      'isEmailVerified': instance.isEmailVerified,
      'isProfileComplete': instance.isProfileComplete,
      'lastActive': instance.lastActive,
      'isOnline': instance.isOnline,
      'approvalStatus': instance.approvalStatus,
      'rejectionReason': instance.rejectionReason,
      'approvedAt': instance.approvedAt,
    };

_$PhotoModelImpl _$$PhotoModelImplFromJson(Map<String, dynamic> json) =>
    _$PhotoModelImpl(
      url: json['url'] as String,
      publicId: json['publicId'] as String?,
      isMain: json['isMain'] as bool? ?? false,
    );

Map<String, dynamic> _$$PhotoModelImplToJson(_$PhotoModelImpl instance) =>
    <String, dynamic>{
      'url': instance.url,
      'publicId': instance.publicId,
      'isMain': instance.isMain,
    };
