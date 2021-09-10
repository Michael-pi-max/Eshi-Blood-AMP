class Donor {
  String? id;
  String? firstname;
  String? lastname;
  String? phoneNumber;
  String? email;
  String? image;
  String? state;
  String? city;
  String? wereda;
  String? gender;
  String? dateOfBirth;
  int? totalDonation;
  String? roleId;
  Donor(
      {this.city,
      this.dateOfBirth,
      this.email,
      this.firstname,
      this.gender,
      this.id,
      this.image,
      this.lastname,
      this.phoneNumber,
      this.roleId,
      this.state,
      this.wereda,
      this.totalDonation});
  static Donor fromJson(Map json) {
    Donor donorInstance = Donor();
    donorInstance.id = json["_id"];
    donorInstance.firstname = json["firstName"];
    donorInstance.lastname = json["lastName"];
    donorInstance.phoneNumber = json["phoneNumber"];
    donorInstance.email = json["email"];
    donorInstance.image = json["image"];
    donorInstance.state = json["address"]["state"];
    donorInstance.city = json["address"]["city"];
    donorInstance.wereda = json["address"]["wereda"];
    donorInstance.gender = json["gender"];
    donorInstance.dateOfBirth = json["dateOfBirth"];
    donorInstance.totalDonation = json["totalDonation"];
    donorInstance.roleId = json["roleId"];
    return donorInstance;
  }

  Map toJson() {
    Map address = {"city": city, "wereda": wereda, "state": state};
    var donorMap = {};
    donorMap["_id"] = id;
    donorMap["firstname"] = firstname;
    donorMap["lastname"] = lastname;
    donorMap["phonenumber"] = phoneNumber;
    donorMap["email"] = email;
    donorMap["image"] = image;
    donorMap["address"] = address;
    donorMap["gender"] = gender;
    donorMap["city"] = city;
    donorMap["wereda"] = wereda;
    donorMap["gender"] = gender;
    donorMap["dateofbirth"] = dateOfBirth;
    donorMap["totaldonation"] = totalDonation;
    donorMap["roleid"] = roleId;
    return donorMap;
  }

  @override
  String toString() {
    return this.toJson().toString();
  }
}
