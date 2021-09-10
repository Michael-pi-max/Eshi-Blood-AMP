import 'package:eshiblood/src/request/data_providers/donor_requestDB.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/utilities/database.dart';

class RequestDB {
  final dbProvider = DatabaseProvider.dbProvider;
  final donorRequestDBProvider = DonorRequestDB();

  Future<List<Request>> getRequests() async {
    final db = await dbProvider.database;
    List<Request> results = [];
    List<Map> querymap = await db!.rawQuery("select * from request ");
    querymap.forEach((requestRow) async {
      Request req = Request(
          unitsNeeded: requestRow["unitsneeded"],
          reason: requestRow["reason"],
          bloodType: requestRow["bloodtype"]);
      req.status = requestRow["status"];
      req.totalDonations = requestRow["totaldonations"];
      req.id = requestRow["id"];
      req.donors =
          await donorRequestDBProvider.getDonorsFromRequest(req); //TODO

      results.add(req);
    });

    return results;
  }

  Future<Request?> getRequest(String id) async {
    final db = await dbProvider.database;
    Request? request;

    try {
      request = await db!.transaction((txn) async {
        List<Map> queryList =
            await txn.rawQuery("select * from request where id='$id'");
        Map requestRow = queryList[0];
        // print("here*****************");
        if (requestRow == null) {
          // print("null returned from $id");
          // return null;
        } else {
          // print("here/////////////////////");
          var req = Request(
            unitsNeeded: requestRow["unitsneeded"],
            reason: requestRow["reason"],
            bloodType: requestRow["bloodtype"],
            status: requestRow["status"],
            totalDonations: requestRow["totaldonations"],
            id: requestRow["id"],
          );
          req.donors = await donorRequestDBProvider.getDonorsFromRequest(req);
          // print(request);
          return req;
          // print(req);

        }
      });
      return request;
      // print(request);

    } catch (e) {
      print("request not found");
    }
  }

  createRequest(Request request) async {
    final db = await dbProvider.database;
    db!.transaction((txn) async {
      List<Map> queryList =
          await txn.rawQuery("select * from request where id='${request.id}'");
      if (queryList.length != 0) {
        print("already exists");
        return null;
      }

      final db = await dbProvider.database;
      var requestIn =
          "insert into request(id,reason,unitsneeded,totaldonations,status,bloodtype) values ('${request.id}','${request.reason}',${request.unitsNeeded},${request.totalDonations},'${request.status}','${request.bloodType}')";
      try {
        txn.rawInsert(requestIn);
        print("inserting request ${request.id} success");
        // print(requestIn);
      } catch (e) {
        print("inserting request ${request.id} failed");
      }
    });
  }

  deleteRequest(String id) async {
    // final db = await dbProvider.database;
    // try {
    //   await db!.transaction((txn) async {
    //     await txn.rawDelete("delete from request where id='$id'");
    //     await txn.rawDelete("delete from request_donor where requestid='$id'");
    //   });
    // } catch (e) {
    //   print("request delete failed");
    // }
  }

  deleteRequestTable() async {
    final db = await dbProvider.database;
    try {
      await db!.transaction((txn) async {
        await txn.rawDelete("delete from request");
        // await txn.rawDelete("delete from request_donor");
      });
    } catch (e) {
      print("request delete failed");
    }
  }
}
