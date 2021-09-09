import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await createDatabase();
    return _database;
  }

  createDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, 'User.db');

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void deleteDB(String table) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, 'User.db');

    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    if (table != "*") {
      await database.execute("drop table $table");
    } else {
      try {
        await database.execute("drop table donor");
      } on Exception catch (e) {
        // TODO
      }
      try {
        await database.execute("drop table appointment");
      } on Exception catch (e) {
        // TODO
      }
      try {
        await database.execute("drop table request");
      } on Exception catch (e) {
        // TODO
      }

      try {
        await database.execute("drop table request_donor");
      } on Exception catch (e) {
        // TODO
      }
      try {
        await database.execute("drop table role");
      } on Exception catch (e) {
        // TODO
      }
      try {
        await database.execute("drop table donationcenter");
      } on Exception catch (e) {
        // TODO
      }
    }
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE Donor("
        "dbId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "id varchar,"
        "fistname varchar,"
        "lastname varchar,"
        "phonenumber varchar,"
        "email varchar,"
        "image varchar,"
        "state varchar,"
        "city varchar,"
        "wereda varchar,"
        "gender varchar,"
        "dateofbirth varchar,"
        "totaldonation int,"
        "roleid varchar )" // role referenced by server id of role
        );
    await database.execute("create table appointment("
        "dbId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "id varchar,"
        "userid varchar,"
        "acceptorid varchar,"
        "startdate varchar,"
        "enddate varchar,"
        "status varchar,"
        "description varchar,"
        "weight varchar,"
        "createdat varchar,"
        "updatedat varchar,"
        "donationcenter varchar,"
        "healthcondition varchar,"
        "tattoo varchar,"
        "pregnant varchar)");

    await database.execute("create table request("
        "dbId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "id varchar,"
        "reason varchar,"
        "totaldonations int,"
        "status varchar,"
        "unitsneeded int,"
        "bloodtype varchar )");

    await database.execute("create table donationcenter("
        "dbId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "id varchar,"
        "status varchar,"
        "totaldonations int,"
        "name varchar,"
        "state varchar,"
        "wereda varchar,"
        "city varchar,"
        "startdate varchar,"
        "enddate varchar )");

    await database.execute("create table request_donor("
        "dbId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "donorid varchar,"
        "requestid varchar )");

    await database.execute("create table role("
        "dbId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "name varchar,"
        "appointmentcreate varchar,"
        "appointmentread varchar,"
        "appointmentupdate varchar,"
        "appointmentdelete varchar,"
        "requestcreate varchar,"
        "requestread varchar,"
        "requestupdate varchar,"
        "requestdelete varchar,"
        "usercreate varchar,"
        "userread varchar,"
        "userupdate varchar,"
        "userdelete varchar,"
        " rolecreate varchar,"
        "roleread varchar,"
        "roleupdate varchar,"
        "roledelete varchar,"
        "donationcentercreate varchar,"
        "donationcenterread varchar,"
        "donationcenterupdate varchar,"
        "donationcenterdelete varchar)");
  }
}
