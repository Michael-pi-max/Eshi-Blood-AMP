import 'package:eshiblood/src/request/model/donor.dart';
import 'package:eshiblood/src/request/model/request.dart';

class DonorRequest {
  String donorId;
  String requestId;
  DonorRequest({required this.donorId, required this.requestId});
  static DonorRequest Relate({required Donor donor, required Request request}) {
    return DonorRequest(donorId: donor.id ?? "", requestId: request.id ?? "");
  }

  @override
  String toString() {
    // TODO: implement toString
    return {"donorId": this.donorId, "requestId": this.requestId}.toString();
  }
}
