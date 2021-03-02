// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profileModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) {
  return ProfileModel(
    DOB: json['DOB'] as String,
    location: json['location'] as String,
    email: json['email'] as String,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phoneNumber: json['phoneNumber'] as String,
    username: json['username'] as String,
  );
}

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'username': instance.username,
      'lastName': instance.lastName,
      'phoneNumber': instance.phoneNumber,
      'DOB': instance.DOB,
      'location': instance.location,
      'email': instance.email,
    };
