import 'package:json_annotation/json_annotation.dart';

part 'profileModel.g.dart';

@JsonSerializable()
class ProfileModel {
  String firstName;
  String username;
  String email;
  String lastName;
  String DOB;
  String location;
  String phoneNumber;

  ProfileModel(
      {this.DOB,
      this.firstName,
      this.lastName,
      this.phoneNumber,
      this.location,
      this.email,
      this.username});

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}
