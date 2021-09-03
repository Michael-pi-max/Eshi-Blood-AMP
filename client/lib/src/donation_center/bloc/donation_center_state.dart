part of 'donation_center_bloc.dart';

@immutable
abstract class DonationCenterState {}

class DonationCenterLoading extends DonationCenterState {}

class DonationCentersLoadSuccess extends DonationCenterState {
  List<DonationCenter> donationCenters = [];
  DonationCentersLoadSuccess(this.donationCenters);
}

class DonationCenterLoadSuccess extends DonationCenterState {
  DonationCenter donationCenter;
  DonationCenterLoadSuccess(this.donationCenter);
}

class DonationCenterOperationFailure extends DonationCenterState {}

class DonationCenterUpdateSuccess extends DonationCenterState {
  DonationCenter donationCenter;
  DonationCenterUpdateSuccess(this.donationCenter);
}

class DonationCenterDeleteSuccess extends DonationCenterState {}

class DonationCenterCreateSuccess extends DonationCenterState {
  DonationCenter donationCenter;
  DonationCenterCreateSuccess(this.donationCenter);
}
