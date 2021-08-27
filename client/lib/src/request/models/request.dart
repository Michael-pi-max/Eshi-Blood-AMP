import 'package:eshiblood/src/request/model/donor.dart';

class Request {
  Request({
    this.id,
    required this.unitsNeeded,
    this.totalDonations,
    required this.reason,
    this.status,
    required this.bloodType,
    this.createdBy,
    this.UpdatedBy,
    this.donors,
  });
  String? id;
  dynamic unitsNeeded;
  dynamic totalDonations;
  String reason;
  String? status;
  String? bloodType;
  String? createdBy;
  String? UpdatedBy;
  List<Donor>? donors;

  factory Request.fromJson(Map<String, dynamic> json) {
    String? createdBy;
    String? updatedBy;
    try {
      createdBy = json["createdBy"]["_id"];
    } catch (e) {
      createdBy = json["createdBy"];
    }

    try {
      updatedBy = json["updatedBy"]["_id"];
    } catch (e) {
      updatedBy = json["updatedBy"];
    }

    return Request(
      id: json["_id"],
      unitsNeeded: json["unitsNeeded"] ?? 0,
      totalDonations: json["totalDonations"] ?? 0,
      reason: json["reason"],
      status: json["status"],
      bloodType: json["bloodType"]["bloodTypeName"],
      createdBy: createdBy,
      UpdatedBy: updatedBy,
      donors: List<Donor>.generate(json["donors"].length,
          (index) => Donor.fromJson(json["donors"][index])),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "unitsNeeded": unitsNeeded,
      "totalDonations": totalDonations,
      "reason": reason,
      "status": status,
      "bloodType": bloodType,
      "createdBy": createdBy,
      "UpdatedBy": UpdatedBy,
      "donors": donors,
    };
  }

  @override
  String toString() {
    return """{\n
        _id: $id, \n
        unitsNeeded: $unitsNeeded,\n
        totalDonations: $totalDonations,\n
        reason: $reason,\n
        status: $status,\n
        bloodType: $bloodType,\n
        createdBy: $createdBy,\n
        UpdatedBy: $UpdatedBy,\n
        donors: $donors,\n
    }""";
  }
}
