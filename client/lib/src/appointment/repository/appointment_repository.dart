import 'package:eshiblood/src/appointment/data_provider/appointmentDB.dart';
import 'package:eshiblood/src/appointment/data_provider/appointment_data_provider.dart';
import 'package:eshiblood/src/appointment/models/appointment.dart';

class AppointmentRepository {
  final AppointmentDataProvider dataProvider;
  final dbProvider = AppointmentDB();
  AppointmentRepository(this.dataProvider);

  Future<Appointment?> fetchOne(dynamic id) async {
    print("from repo");
    // return this.dataProvider.fetchOne(id);

    try {
      print("fetching from network");
      Appointment appt = await this.dataProvider.fetchOne(id);
      try {
        print("inserting into database appointment");
        // await dbProvider.deleteAppointment(id);
        await dbProvider.createAppointment(appt);
      } catch (e) {
        print("database save appointment error");
      }
    } catch (e) {
      print("fetching from database");
      Appointment? appt = await dbProvider.getAppointment(id);
      return appt;
    }
  }

  Future<Appointment?> create(Appointment appointment) {
    print("from repo");
    return this.dataProvider.create(appointment);
  }

  Future<Appointment> update(dynamic id, Appointment appointment) async {
    var appt = await this.dataProvider.update(id, appointment);
    try {
      print("inserting into database appointment");
      // await dbProvider.deleteAppointment(id);
      await dbProvider.createAppointment(appt);
    } catch (e) {
      print("unable to write database");
    }
    return appt;
  }

  Future<List<Appointment>> fetchAll() async {
    print("from repo");
    // return this.dataProvider.fetchAll();
    try {
      print("fetching from network");
      var appts = await this.dataProvider.fetchAll();
      try {
        if (appts.length != 0) {
          print("deleting appointment records");
          // await dbProvider.deleteAppointmentTable();
          print("inserting into database appointment");
          appts.forEach((appt) async {
            await dbProvider.createAppointment(appt);
          });
          return appts;
        } else {
          return [];
        }
      } catch (e) {
        print("database save appointment error");
        return [];
      }
    } catch (e) {
      print("fetching from database");
      var appts = await dbProvider.getAppointments();
      print(
          '0000000000000000000000000000000000000000000000000000000000000000000000000000000');
      print(appts);
      print(
          '00000000000000000000000000000000000000000000000000000000000000000000000000');
      return appts;
    }
  }

  Future<List<Appointment>> fetchAllHistory() async {
    print("from repo");
    return this.dataProvider.fetchAllHistory();
  }

  Future<void> delete(dynamic id) async {
    // this.dataProvider.delete(id);
    try {
      await dbProvider.deleteAppointment(id);
    } catch (e) {}
    await this.dataProvider.delete(id);
  }
}
