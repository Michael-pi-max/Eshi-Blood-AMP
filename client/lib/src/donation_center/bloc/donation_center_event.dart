part of 'donation_center_bloc.dart';

@immutable
abstract class DonationCenterEvent {}

class DonationCenterLoad extends DonationCenterEvent {
  DonationCenter donationCenter;

  DonationCenterLoad(DonationCenter this.donationCenter);
}

class DonationCentersLoad extends DonationCenterEvent {}

class DonationCenterCreate extends DonationCenterEvent {
  DonationCenter donationCenter;
  DonationCenterCreate(this.donationCenter);
  @override
  String toString() {
    return "DonationCenter Created {DonationCenter: $donationCenter";
  }
}

class DonationCenterUpdate extends DonationCenterEvent {
  DonationCenter donationCenter;
  DonationCenterUpdate(this.donationCenter);
  @override
  String toString() {
    return "DonationCenter Updated {DonationCenter: $donationCenter";
  }
}

class DonationCenterDelete extends DonationCenterEvent {
  DonationCenter donationCenter;
  DonationCenterDelete(this.donationCenter);
  @override
  String toString() {
    return "DonationCenter Deleted {DonationCenter: $donationCenter";
  }
}
