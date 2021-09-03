part of 'form_donation_center_bloc.dart';

class FormDonationCenterState extends Equatable {
  String name = "";
  String state = "Addis Ababa";
  String wereda = "Addis Ketema";
  String city = "01";
  DateTime startDate = DateTime.now().add(const Duration(hours: 1));
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  bool get isNameValid => name.length != 0;

  bool get isStateValid => state.length != 0;

  bool get isWeredaValid => wereda.length != 0;

  bool get isCityValid => city.length != 0;

  bool get isStartDateValid {
    if (endDate.compareTo(startDate) < 0) {
      this.endDate = DateTime.now().add(const Duration(days: 1));
      return DateTime.now().compareTo(startDate) <= 0;
    } else {
      return DateTime.now().compareTo(startDate) <= 0;
    }
  }

  bool get isEndDateValid => startDate.compareTo(endDate) < 0;

  @override
  List<Object?> get props => [name, state, wereda, city, startDate, endDate];

  FormDonationCenterState copyWith(
      {String? name,
      String? state,
      String? wereda,
      String? city,
      DateTime? startDate,
      DateTime? endDate}) {
    var newInstance = FormDonationCenterState();
    newInstance.name = name ?? this.name;
    newInstance.state = state ?? this.state;
    newInstance.wereda = wereda ?? this.wereda;
    newInstance.city = city ?? this.city;
    newInstance.startDate = startDate ?? this.startDate;
    newInstance.endDate = endDate ?? this.endDate;

    return newInstance;
  }

  DonationCenter toDonationCenter() {
    Map<String, dynamic> dcMap = {
      "name": this.name,
      "address": {
        "state": this.state,
        "city": this.city,
        "wereda": this.wereda,
      },
      "timeSlot": {
        "startDate": this.startDate.toString(),
        "endDate": this.endDate.toString(),
      },
      "status": "open"
    };
    print(dcMap);
    return DonationCenter.fromJson(dcMap);
  }

  bool formValid() {
    print({
      "name": isNameValid,
      "city": isCityValid,
      "wereda": isWeredaValid,
      "state": isStateValid,
      "start": isStartDateValid,
      "end": isStartDateValid
    });
    return isNameValid &&
        isCityValid &&
        isWeredaValid &&
        isStateValid &&
        isStartDateValid &&
        isEndDateValid;
  }

  @override
  String toString() {
    return {
      "name": name,
      "state": state,
      "city": city,
      "wereda": wereda,
      "timeSlot": {
        "startDate": startDate,
        "endDate": endDate,
      },
      "status": "open"
    }.toString();
  }
}

class DonationCenterFormSubmitPending extends FormDonationCenterState {}

class DonationCenterFormSubmitSuccess extends FormDonationCenterState {}

class DonationCenterFormFailed extends FormDonationCenterState {
  DonationCenterFormFailed(String errMsg) {
    print(errMsg);
  }
}

class DonationCenterFormNameError extends FormDonationCenterState {
  String errMsg = "Name is not valid";
  DonationCenterFormNameError() {
    print(errMsg);
  }
}

class DonationCenterFormStateError extends FormDonationCenterState {
  String errMsg = "State is not valid";
  DonationCenterFormStateError() {
    print(errMsg);
  }
}

class DonationCenterFormWeredaError extends FormDonationCenterState {
  String errMsg = "wereda is not valid";
  DonationCenterFormWeredaError() {
    print(errMsg);
  }
}

class DonationCenterFormCityError extends FormDonationCenterState {
  String errMsg = "City is not valid";
  DonationCenterFormCityError() {
    print(errMsg);
  }
}

class DonationCenterFormStartDateError extends FormDonationCenterState {
  String errMsg = "Start Date is not valid";
  DonationCenterFormStartDateError() {
    print(errMsg);
  }
}

class DonationCenterFormEndDateError extends FormDonationCenterState {
  String errMsg = "End Date is not valid";
  DonationCenterFormEndDateError() {
    print(errMsg);
  }
}
