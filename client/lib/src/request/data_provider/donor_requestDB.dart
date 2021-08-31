import 'package:eshiblood/src/request/data_providers/donorDB.dart';
import 'package:eshiblood/src/request/model/donor.dart';
import 'package:eshiblood/src/request/model/donor_request.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/utilities/database.dart';

class DonorRequestDB {
  final dbProvider = DatabaseProvider.dbProvider;
  final donorDBProvider = DonorDB();

  Future<List<Donor>> getDonorsFromRequest(Request request) async {
    final db = await dbProvider.database;
    List<Donor> donors = [];
    List<Map> querymap = await db!.rawQuery(
        "select * from request_donor where requestid = '${request.id}' ");
    querymap.forEach((donorRequestRow) async {
      try {
        var donor = await donorDBProvider.getDonor(donorRequestRow["donorid"]);
        donors.add(donor!);
      } catch (e) {
        print("donor not found db ${donorRequestRow['donorid']}");
      }
    });

    return donors;
  }

  createDonorRequest(DonorRequest donorRequest) async {
    final db = await dbProvider.database;
    db!.transaction((txn) async {
      final db = await dbProvider.database;
      var donorRequestIn =
          "insert into request_donor(donorid,requestid) values('${donorRequest.donorId}','${donorRequest.requestId}')";
      try {
        txn.rawInsert(donorRequestIn);
        print(
            "inserting donorRequest  donor:${donorRequest.donorId}  request:${donorRequest.requestId} success");
      } catch (e) {
        print(
            "inserting donorRequest donor:${donorRequest.donorId}  request:${donorRequest.requestId} failed");
      }
    });
  }

  Future<List<DonorRequest>> getDonorRequests() async {
    final db = await dbProvider.database;
    List<DonorRequest> donors = [];
    List<Map> querymap = await db!.rawQuery("select * from request_donor ");
    querymap.forEach((donorRequestRow) {
      var donor = DonorRequest(
          donorId: donorRequestRow["donorid"],
          requestId: donorRequestRow["requestid"]);

      donors.add(donor);
    });

    return donors;
  }
}
