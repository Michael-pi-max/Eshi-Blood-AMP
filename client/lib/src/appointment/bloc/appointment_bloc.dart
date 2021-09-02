import 'package:eshiblood/src/appointment/repository/appointment_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'appointment_event.dart';
import 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  final AppointmentRepository appointmentRepository;

  AppointmentBloc({required this.appointmentRepository})
      : super(AppointmentLoading());

  @override
  Stream<AppointmentState> mapEventToState(AppointmentEvent event) async* {
    if (event is AppointmentLoad) {
      yield AppointmentLoading();
      try {
        final appointments = await appointmentRepository.fetchAll();
        print(appointments);
        yield AppointmentOperationSuccess(appointments);
      } catch (e) {
        print(e);
        yield AppointmentOperationFailure();
      }
    }
    if (event is AppointmentLoadHistory) {
      yield AppointmentLoading();
      try {
        final appointments = await appointmentRepository.fetchAllHistory();
        yield AppointmentOperationSuccess(appointments);
      } catch (e) {
        print(e);
        yield AppointmentOperationFailure();
      }
    }
    if (event is AppointmentLoadOne) {
      yield AppointmentLoading();
      try {
        final appointment =
            await appointmentRepository.fetchOne(event.appointment.id);
        yield AppointmentOperationSuccess([appointment!]);
      } catch (e) {
        print(e);
        yield AppointmentOperationFailure();
      }
    }

    if (event is AppointmentCreate) {
      // yield AppointmentLoading();
      try {
        await appointmentRepository.create(event.appointment);
        final appointments = await appointmentRepository.fetchAll();
        yield AppointmentOperationSuccess(appointments);
      } catch (e) {
        print(e);
        yield AppointmentOperationFailure();
      }
    }

    if (event is AppointmentUpdate) {
      // yield AppointmentLoading();
      try {
        await appointmentRepository.update(
            event.appointment.id, event.appointment);
        final appointments = await appointmentRepository.fetchAll();
        yield AppointmentOperationSuccess(appointments);
      } catch (e) {
        print(e);
        yield AppointmentOperationFailure();
      }
    }

    if (event is AppointmentDelete) {
      try {
        await appointmentRepository.delete(event.id);
        final appointments = await appointmentRepository.fetchAll();
        yield AppointmentOperationSuccess(appointments);
      } catch (_) {
        yield AppointmentOperationFailure();
      }
    }
  }
}
