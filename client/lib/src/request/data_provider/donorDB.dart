import 'package:eshiblood/src/request/model/donor.dart';
import 'package:eshiblood/src/utilities/database.dart';

class DonorDB {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<Donor>> getDonors() async {
    final db = await dbProvider.database;
    List<Donor> donors = [];
    List<Map> querymap = await db!.rawQuery("select * from donor ");
    querymap.forEach((donorRow) {
      var donor = Donor(
        id: donorRow["id"],
        fistname: donorRow["fistname"],
        lastname: donorRow["lastname"],
        phoneNumber: donorRow["phonenumber"],
        email: donorRow["email"],
        image: donorRow["image"],
        state: donorRow["state"],
        city: donorRow["city"],
        wereda: donorRow["wereda"],
        gender: donorRow["gender"],
        dateOfBirth: donorRow["dateofbirth"],
        totalDonation: int.tryParse(donorRow["totaldonation"]),
        roleId: donorRow["roleid"],
      );
      donors.add(donor);
    });

    return donors;
  }

  Future<Donor?> getDonor(String id) async {
    final db = await dbProvider.database;
    Donor? donor;

    // try {
    donor = await db!.transaction((txn) async {
      print(id);
      List<Map> queryList =
          await txn.rawQuery("select * from donor where id='$id'");
      Map donorRow = queryList[0];

      if (donorRow.length == 0) {
        // print("null returned from $id");
        // return null;
      } else {
        // print("here/////////////////////");
        // print(donorRow);
        var _donor = Donor(
          id: donorRow["id"],
          fistname: donorRow["fistname"],
          lastname: donorRow["lastname"],
          phoneNumber: donorRow["phonenumber"],
          email: donorRow["email"],
          image: donorRow["image"],
          state: donorRow["state"],
          city: donorRow["city"],
          wereda: donorRow["wereda"],
          gender: donorRow["gender"],
          dateOfBirth: donorRow["dateofbirth"],
          totalDonation: int.tryParse(donorRow["totaldonation"]),
          roleId: donorRow["roleid"],
        );

        return _donor;
        // print(req);

      }
    });
    // print(donor);
    return donor;
    // } catch (e) {
    //   print("donor not found");
    // }
  }

  createDonor(Donor donor) async {
    final db = await dbProvider.database;
    db!.transaction((txn) async {
      List<Map> queryList =
          await txn.rawQuery("select * from donor where id='${donor.id}'");
      if (queryList.length != 0) {
        print("already exists");
      }

      final db = await dbProvider.database;
      var donorIn = "insert into donor(id, fistname, lastname,"
          " phonenumber, email, image, state, city, wereda, "
          "gender, dateofbirth, totaldonation, roleid)"
          " values ( '${donor.id}' ,'${donor.fistname}' ,'${donor.lastname}' ,'${donor.phoneNumber}' ,'${donor.email}' ,"
          "'${donor.image}' ,'${donor.state}' ,'${donor.city}' ,'${donor.wereda}' ,'${donor.gender}' ,'${donor.dateOfBirth}' "
          ",'${donor.totalDonation}' ,'${donor.roleId}'"
          ")";
      try {
        txn.rawInsert(donorIn);
        print("inserting donor ${donor.id} success");
      } catch (e) {
        print("inserting donor ${donor.id} failed");
      }
    });
  }

  deleteDonor(String id) async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from donor where id='$id'");
        await txn.rawDelete("delete from request_donor where donorid='$id'");
      });
    } catch (e) {
      print("donor delete failed");
    }
  }

  deleteDonorTable() async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from donor");
        // await txn.rawDelete("delete from request_donor");
      });
    } catch (e) {
      print("donor delete failed");
    }
  }
}
