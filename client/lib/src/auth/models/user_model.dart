import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

@immutable
class User extends Equatable {
  final String? id;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final dynamic image;
  final String dateOfBirth;
  final String? lastDonation;
  final String? password;
  final String bloodType;
  final String gender;
  final dynamic role;
  final dynamic totalDonations;
  final dynamic appointed;

  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.image,
    required this.dateOfBirth,
    this.lastDonation,
    this.password,
    required this.bloodType,
    this.role,
    required this.gender,
    this.totalDonations,
    this.appointed,
  });

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        phoneNumber,
        email,
        image,
        dateOfBirth,
        lastDonation,
        password,
        bloodType,
        role,
        gender,
        totalDonations,
        appointed,
      ];

  @override
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['_id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        phoneNumber: json['phoneNumber'],
        email: json['email'],
        image: json['image'],
        dateOfBirth: json['dateOfBirth'],
        bloodType: json['bloodType']['bloodTypeName'],
        role: json['roles'],
        gender: json['gender'],
        totalDonations: json['totalDonations'],
        appointed: json['appointed'],
        lastDonation: json['lastDonation']);
  }

  @override
  String toString() =>
      'User\n  {id: $id, firstName: $firstName, lastName:$lastName, phoneNumber: $phoneNumber,email: $email, image: $image,dateOfBirth: $dateOfBirth, bloodType $bloodType, role: $role}';
}
