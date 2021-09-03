part of 'form_donation_center_bloc.dart';

@immutable
abstract class FormDonationCenterEvent {}

class NameChange extends FormDonationCenterEvent{
  String name;
  NameChange(this.name);
}


class StateChange extends FormDonationCenterEvent{
  String state;
  StateChange(this.state);
}


class WeredaChange extends FormDonationCenterEvent{
  String wereda;
  WeredaChange(this.wereda);
}


class CityChange extends FormDonationCenterEvent{
  String city;
  CityChange(this.city);
}


class startDateChange extends FormDonationCenterEvent{
  DateTime startDate;
  startDateChange(this.startDate);
}


class endDateChange extends FormDonationCenterEvent{
  DateTime endDate;
  endDateChange(this.endDate);
}



class DonationCenterFormSubmit extends FormDonationCenterEvent{}

