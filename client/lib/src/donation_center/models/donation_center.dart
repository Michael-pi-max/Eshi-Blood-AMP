class DonationCenter {
  DonationCenter(
      {this.id,
      required this.name,
      this.createdBy,
      this.updatedBy,
      this.status,
      this.timeSlot,
      required this.address,
      this.totalDonations});
  String? id;
  String name;
  String? status;
  String? createdBy;
  String? updatedBy;
  Map? timeSlot;
  Map address;
  int? totalDonations;

  factory DonationCenter.fromJson(Map<String, dynamic> json) {
    print(json["totalDonations"].runtimeType);

    print(
        "*********************** DonationCenter fromJson ****************************");
    String? createdBy;
    String? updatedBy;
    // print(json["createdBy"]["_id"].toString());
    try {
      // account for different types of response
      createdBy = json["createdBy"]["_id"];
    } catch (e) {
      createdBy = json["createdBy"];
    }

    try {
      updatedBy = json["updatedBy"]["_id"];
    } catch (e) {
      updatedBy = json["updatedBy"];
    }

    return DonationCenter(
      id: json["_id"],
      name: json["name"],
      address: json["address"],
      timeSlot: json["timeSlot"],
      status: json["status"],
      createdBy: createdBy,
      // updatedBy: updatedBy,
      // totalDonations: json["totalDonations"]
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "address": address,
      "timeSlot": timeSlot,
      "status": status,
      "createdBy": createdBy,
      "updatedBy": updatedBy,
      "totalDonations": totalDonations
    };
  }

  @override
  String toString() {
    // TODO: implement toString
    return """{ _id: $id, name: $name,status: $status,address: $address,createdBy: $createdBy,UpdatedBy: $updatedBy,timeSlot: $timeSlot,totalDonations: $totalDonations}""";
  }
}
