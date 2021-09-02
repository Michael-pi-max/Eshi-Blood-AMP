import 'package:equatable/equatable.dart';
import 'package:eshiblood/src/appointment/models/models.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  @override
  List<Object> get props => [];
}

class AppointmentLoading extends AppointmentState {}

class AppointmentOperationSuccess extends AppointmentState {
  final List<Appointment> appointments;

  AppointmentOperationSuccess([this.appointments = const []]);

  @override
  List<Object> get props => [appointments];
}

class AppointmentOperationFailure extends AppointmentState {}
