import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class Role extends Equatable {
  Role({
    this.id,
    required this.roleName,
    required this.privileges,
  });

  final String? id;
  final String roleName;
  final List<dynamic> privileges;

  @override
  List<Object> get props => [roleName, privileges];

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
        id: json['_id'],
        roleName: json['roleName'],
        privileges: json['privileges']);
  }

  @override
  String toString() => 'Role { roleName: $roleName, privileges: $privileges }';
}
