import 'package:eshiblood/src/request/data_providers/donorDB.dart';
import 'package:eshiblood/src/request/data_providers/donor_requestDB.dart';
import 'package:eshiblood/src/request/data_providers/requestDB.dart';
import 'package:eshiblood/src/request/data_providers/request_data_provider.dart';
import 'package:eshiblood/src/request/model/donor_request.dart';
import 'package:eshiblood/src/request/model/request.dart';

class RequestRepository {
  final RequestDataProvider dataProvider;
  final RequestDB dbProvider = RequestDB();
  final DonorDB donorDBProvider = DonorDB();
  final DonorRequestDB donorRequestDBProvider = DonorRequestDB();

  RequestRepository({required this.dataProvider});

  Future<Request> createRequest(Request request) async {
    return await dataProvider.createRequest(request);
  }

  Future<List<Request>> getRequests() async {
    // return await dataProvider.getRequests();
    try {
      print("requests fetch from network");
      var requests = await dataProvider.getRequests();
      try {
        print("requests saving to db");
        requests.forEach((request) async {
          await dbProvider.createRequest(request);
          // print(request.donors![0].runtimeType.toString() + "TYpe");r
          request.donors!.forEach((donor) async {
            await donorDBProvider.createDonor(donor);
            await donorRequestDBProvider.createDonorRequest(
                DonorRequest(donorId: donor.id!, requestId: request.id!));
          });
        });
      } catch (e) {
        print("requests saving failed");
        return [];
      }

      return requests;
    } catch (e) {
      print(e);
      try {
        print("requests fetch from db");
        var requests = await dbProvider.getRequests();
        //TODO retrieve donors from the donorRequest table
        int i = 0;
        requests.forEach((request) async {
          var donors =
              await donorRequestDBProvider.getDonorsFromRequest(request);
          requests[i].donors = donors;
          i++;
        });
        return requests;
      } catch (e) {
        print("requests fetch from db failed");
        return [];
      }
    }
  }

  Future<Request> getRequest(String id) async {
    // return await dataProvider.getRequest(id);
    try {
      print("request fetch from network");
      var request = await dataProvider.getRequest(id);
      try {
        print("request saving to db");

        await dbProvider.createRequest(request);
        return request;
      } catch (e) {
        print("request saving failed");
        return request;
      }
    } catch (e) {
      try {
        print("request fetch from db");
        var request = await dbProvider.getRequest(id);
        var donors =
            await donorRequestDBProvider.getDonorsFromRequest(request!);
        request.donors = donors;
        return request;
      } catch (e) {
        throw Exception("invalid id or can't get $id");
      }
    }
  }

  Future<void> updateRequest(Request request) async {
    var updatedRequest = await dataProvider.updateRequest(request);
    await dbProvider.deleteRequest(request.id ?? "");
    await dbProvider.createRequest(updatedRequest);
  }

  Future<void> deleteRequest(String id) async {
    await dataProvider.deleteRequest(id);
    try {
      dbProvider.deleteRequest(id);
    } catch (e) {
      print(
          "db request deletion exception may be id not found or not successful");
    }
  }

  Future<Request> acceptRequest(dynamic id, Request request) async {
    return await dataProvider.acceptRequest(id, request);
  }
}
