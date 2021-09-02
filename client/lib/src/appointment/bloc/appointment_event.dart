import 'package:eshiblood/src/appointment/models/models.dart';
import 'package:equatable/equatable.dart';

abstract class AppointmentEvent extends Equatable {
  const AppointmentEvent();
}

class AppointmentLoad extends AppointmentEvent {
  const AppointmentLoad();

  @override
  List<Object> get props => [];
}
class AppointmentLoadHistory extends AppointmentEvent {
  const AppointmentLoadHistory();

  @override
  List<Object> get props => [];
}

class AppointmentLoadOne extends AppointmentEvent {
  final Appointment appointment;
  const AppointmentLoadOne(this.appointment);

  @override
  List<Object> get props => [appointment];
}

class AppointmentCreate extends AppointmentEvent {
  final Appointment appointment;
  const AppointmentCreate(this.appointment);

  @override
  List<Object> get props => [appointment];

  @override
  String toString() => 'Appointment Created {appointment : $appointment}';
}

class AppointmentUpdate extends AppointmentEvent {
  final Appointment appointment;
  const AppointmentUpdate(this.appointment);

  @override
  List<Object?> get props => [appointment];

  @override
  String toString() => 'Appointment Updated {appointment: $appointment}';
}

class AppointmentDelete extends AppointmentEvent {
  final String id;

  const AppointmentDelete(this.id);

  @override
  List<Object> get props => [id];

  @override
  toString() => 'Appointment Deleted {Appointment Id: $id}';
}
