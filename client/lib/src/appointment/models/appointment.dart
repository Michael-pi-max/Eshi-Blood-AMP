import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum Status { active, pending, closed, rejected, canceled }

// @immutable
// class Address extends Equatable{
//   final String state;
//   final String city;
//   final String woreda;

//   Address({
//     required this.state,
//     required this.city,
//     required this.woreda
//   })

//   @override
//   List<Object?> get props => [
//     state,
//     city,
//     woreda
//   ];
// }

// @immutable
// class DonationCenter extends Equatable {
//   final String id;
//   final String name;
//   final dynamic address;
//   final String status;
//   final int totalDonations;
//   final dynamic createdBy;
//   final dynamic updatedBy;

//   DonationCenter({
//     required this.id,
//     required this.name,
//     required this.address,
//     required this.status,
//     required this.totalDonations,
//     required this.createdBy,
//     required this.updatedBy,
//   })

//   @override
//   List<Object?> get props => [
//     id,name,address,status,totalDonations,createdBy,updatedBy
//   ];

//   // @override
//   // factory DonationCenter.fromJson(Map<String,dynamic> json){
//   //   return DonationCenter(id: json["_id"], donor: ["userId"], acceptor: ["acceptorId"], startDate: ["startDate"], endDate: ["endDate"], status: ["status"], appointmentDescription: ["appointmentDescription"], weight: ["weight"], createdAt: ["createdAt"], updatedAt: ["updatedAt"], donationCenter: ["donationCenter"]);
//   // }

// }

@immutable
class Appointment extends Equatable {
  final dynamic id;
  final dynamic userId;
  final dynamic acceptorId;
  final String? startDate;
  final String? endDate;
  final String? status;
  final String? appointmentDescription;
  final dynamic weight;
  final dynamic createdAt;
  final dynamic updatedAt;
  final dynamic donationCenter;
  final String? healthCondition;
  final String? tattoo;
  final String? pregnant;

  Appointment(
      {this.id,
      this.userId,
      this.acceptorId,
      this.startDate,
      this.endDate,
      this.status,
      this.appointmentDescription,
      this.weight,
      this.createdAt,
      this.updatedAt,
      this.donationCenter,
      this.healthCondition,
      this.tattoo,
      this.pregnant});

  @override
  List<Object?> get props => [
        id,
        userId,
        acceptorId,
        startDate,
        endDate,
        status,
        appointmentDescription,
        weight,
        donationCenter,
        healthCondition,
        pregnant,
        tattoo,
        createdAt,
        updatedAt
      ];

  @override
  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
        id: json["_id"],
        userId: json["userId"],
        acceptorId: json["acceptorId"] ?? "",
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        appointmentDescription: json["appointmentDescription"],
        weight: json["weight"],
        donationCenter: json["donationCenter"],
        healthCondition: json["healthCondition"],
        tattoo: json["tattoo"],
        pregnant: json["pregnant"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"]);
  }

  @override
  String toString() {
    return 'Appointment {userId : $userId, apppointmentDescription: $appointmentDescription}';
  }
}
