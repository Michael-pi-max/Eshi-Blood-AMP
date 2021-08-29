import 'package:eshiblood/src/donation_center/models/donation_center.dart';
import 'package:eshiblood/src/utilities/database.dart';

class DonationCenterDB {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<List<DonationCenter>> getDonationCenters() async {
    final db = await dbProvider.database;
    List<DonationCenter> donationCenter = [];
    List<Map> querymap = await db!.rawQuery("select * from donationcenter ");
    querymap.forEach((donationCenterRow) {
      var address = {
        "state": donationCenterRow["state"],
        "wereda": donationCenterRow["wereda"],
        "city": donationCenterRow["city"]
      };
      var timeSlot = {
        "startDate": donationCenterRow["startdate"],
        "endDate": donationCenterRow["enddate"],
      };
      var dc = DonationCenter(
        id: donationCenterRow["id"],
        status: donationCenterRow["status"],
        totalDonations: donationCenterRow["totaldonations"],
        address: address,
        name: donationCenterRow["name"],
        timeSlot: timeSlot,
      );
      donationCenter.add(dc);
    });

    return donationCenter;
  }

  Future<DonationCenter?> getDonationCenter(String id) async {
    final db = await dbProvider.database;
    DonationCenter? donationCenter;

    try {
      donationCenter = await db!.transaction((txn) async {
        List<Map> queryList =
            await txn.rawQuery("select * from donationcenter where id='$id'");
        Map donationCenterRow = queryList[0];

        if (donationCenterRow == null) {
          // print("null returned from $id");
          // return null;
        } else {
          print("here/////////////////////");
          var address = {
            "state": donationCenterRow["state"],
            "wereda": donationCenterRow["wereda"],
            "city": donationCenterRow["city"]
          };
          var timeSlot = {
            "startDate": donationCenterRow["startdate"],
            "endDate": donationCenterRow["enddate"],
          };
          var dc = DonationCenter(
            id: donationCenterRow["id"],
            status: donationCenterRow["status"],
            totalDonations: donationCenterRow["totaldonations"],
            address: address,
            name: donationCenterRow["name"],
            timeSlot: timeSlot,
          );

          return dc;
          // print(req);

        }
      });
      print(donationCenter);
      return donationCenter;
    } catch (e) {
      print("donation center not found");
    }
  }

  createDonationCenter(DonationCenter donationCenter) async {
    print("CreateDonationCenter accessed");
    final db = await dbProvider.database;
    db!.transaction((txn) async {
      List<Map> queryList = await txn.rawQuery(
          "select * from donationcenter where id='${donationCenter.id}'");
      if (queryList.length != 0) {
        print("already exists");
        return null;
      }

      final db = await dbProvider.database;
      var endDate;
      var startDate;
      try {
        endDate = donationCenter.timeSlot!['endDate'];
        startDate = donationCenter.timeSlot!['startDate'];
      } catch (e) {
        endDate = DateTime.now();
        startDate = DateTime.now().add(Duration(days: 1));
      }
      var donationCenterIn =
          "insert into donationcenter(id,status,totaldonations,state,wereda,city,name,startdate,enddate) values ('${donationCenter.id}','${donationCenter.status}',${donationCenter.totalDonations},'${donationCenter.address['state']}','${donationCenter.address['wereda']}','${donationCenter.address['city']}','${donationCenter.name}','${startDate}','${endDate}')";
      try {
        txn.rawInsert(donationCenterIn);
        print("inserting donation center ${donationCenter.id} success");
        // print(donationCenter);
      } catch (e) {
        print("inserting donation center ${donationCenter.id} failed");
      }
    });
  }

  deleteDonationCenter(String id) async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from donationcenter where id='$id'");
      });
    } catch (e) {
      print("donation center delete failed");
    }
  }

  deleteDonationCenterTable() async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from donationcenter");
      });
    } catch (e) {
      print("donation center delete failed");
    }
  }
}
