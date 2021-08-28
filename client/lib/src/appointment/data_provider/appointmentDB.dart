import 'dart:convert';

import 'package:eshiblood/src/appointment/models/appointment.dart';
import 'package:eshiblood/src/request/data_providers/donorDB.dart';
import 'package:eshiblood/src/utilities/database.dart';

class AppointmentDB {
  final dbProvider = DatabaseProvider.dbProvider;
  final donorDBProvider = DonorDB();

  Future<List<Appointment>> getAppointments() async {
    final db = await dbProvider.database;
    List<Appointment> appointments = [];
    List<Map> querymap = await db!.rawQuery("select * from appointment ");
    var appts = List.generate(querymap.length, (i) {
      var appointmentRow = querymap[i];
      var appt = Appointment(
          acceptorId: appointmentRow["acceptorid"],
          userId: donorDBProvider.getDonor(appointmentRow["userid"]),
          startDate: appointmentRow["startdate"],
          appointmentDescription: appointmentRow["description"],
          createdAt: appointmentRow["createdat"],
          endDate: appointmentRow["enddate"],
          id: appointmentRow["id"],
          updatedAt: appointmentRow["updatedat"],
          status: appointmentRow["status"],
          pregnant: appointmentRow["pregnant"],
          donationCenter: appointmentRow["donationcenter"],
          healthCondition: appointmentRow["healthcondition"],
          tattoo: appointmentRow["tattoo"],
          weight: appointmentRow["weight"]);
      return appt;
    });

    print("++++++++++++++++++++++++++++++++++++++++++++");
    print(appts.length);
    return appts;
  }

  Future<Appointment?> getAppointment(String id) async {
    final db = await dbProvider.database;
    Appointment? appointment;

    try {
      appointment = await db!.transaction((txn) async {
        List<Map> queryList =
            await txn.rawQuery("select * from appointment where id='$id'");
        Map appointmentRow = queryList[0];
        print(
            "#############################################################################");
        print(appointmentRow);
        print(
            "#############################################################################");

        if (appointmentRow.length == 0) {
          // print("null returned from $id");
          // return null;
        } else {
          print("here/////////////////////");
          var appt = Appointment(
              acceptorId: appointmentRow[
                  "acceptorid"], //TODO include in database creation
              userId: appointmentRow["userid"],
              startDate: appointmentRow["startdate"],
              appointmentDescription: appointmentRow["description"],
              createdAt: appointmentRow["createdat"],
              endDate: appointmentRow["enddate"],
              id: appointmentRow["id"],
              updatedAt: appointmentRow["updatedat"],
              status: appointmentRow["status"],
              pregnant: appointmentRow["pregnant"],
              donationCenter: appointmentRow["donationcenter"],
              healthCondition: appointmentRow["healthcondition"],
              tattoo: appointmentRow["tattoo"],
              weight: appointmentRow["weight"]);

          return appt;
          // print(req);

        }
      });
      print(appointment);
      return appointment;
    } catch (e) {
      print("appointment not found");
    }
  }

  createAppointment(Appointment appointment) async {
    final db = await dbProvider.database;
    db!.transaction((txn) async {
      List<Map> queryList = await txn
          .rawQuery("select * from appointment where id='${appointment.id}'");
      if (queryList.length != 0) {
        print("already exists");
        return null;
      }

      final db = await dbProvider.database;
      var appointmentIn =
          "insert into appointment(id,userid,acceptorid,startdate,enddate,status,"
          "description,weight,createdat,updatedat,donationcenter,healthcondition,tattoo,pregnant) values"
          "('${appointment.id}' ,'${appointment.userId}', '${appointment.acceptorId}' ,'${appointment.startDate}' "
          ",'${appointment.endDate}' ,'${appointment.status}' ,'${appointment.appointmentDescription}' ,"
          "'${appointment.weight}' ,'${appointment.createdAt}' ,'${appointment.updatedAt}' ,"
          "'${appointment.donationCenter}' ,'${appointment.healthCondition}' ,'${appointment.tattoo}' ,"
          "'${appointment.pregnant}')";
      try {
        txn.rawInsert(appointmentIn);
        print("inserting appointment ${appointment.id} success");
      } catch (e) {
        print("inserting appointment ${appointment.id} failed");
      }
    });
  }

  deleteAppointment(String id) async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from appointment where id='$id'");
      });
    } catch (e) {
      print("appointment delete failed");
    }
  }

  deleteAppointmentTable() async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from appointment ");
      });
    } catch (e) {
      print("appointment  delete failed");
    }
  }
}
