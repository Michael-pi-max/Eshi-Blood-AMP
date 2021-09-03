import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eshiblood/src/donation_center/models/donation_center.dart';
import 'package:eshiblood/src/donation_center/repository/donation_center_repository.dart';

import 'package:meta/meta.dart';

part 'donation_center_event.dart';
part 'donation_center_state.dart';

class DonationCenterBloc
    extends Bloc<DonationCenterEvent, DonationCenterState> {
  final DonationCenterRepository donationCenterRepository;
  DonationCenterBloc({required this.donationCenterRepository})
      : super(DonationCenterLoading());

  @override
  Stream<DonationCenterState> mapEventToState(
      DonationCenterEvent event) async* {
    if (event is DonationCenterLoad) {
      yield DonationCenterLoading();
      try {
        final donationCenter = await donationCenterRepository
            .getDonationCenter(event.donationCenter.id ?? ""); //TODO
        yield DonationCenterLoadSuccess(donationCenter!);
      } catch (e) {
        yield DonationCenterOperationFailure();
      }
    }
    if (event is DonationCentersLoad) {
      yield DonationCenterLoading();
      try {
        final donationCenters =
            await donationCenterRepository.getDonationCenters();
        yield DonationCentersLoadSuccess(donationCenters);
      } catch (e) {
        yield DonationCenterOperationFailure();
      }
    }
    if (event is DonationCenterCreate) {
      yield DonationCenterLoading();
      try {
        await donationCenterRepository
            .createDonationCenter(event.donationCenter);
        final donationCenter = await donationCenterRepository
            .getDonationCenter(event.donationCenter.id ?? '');
        yield DonationCenterCreateSuccess(donationCenter!);
      } catch (e) {
        yield DonationCenterOperationFailure();
      }
    }
    if (event is DonationCenterUpdate) {
      yield DonationCenterLoading();
      try {
        await donationCenterRepository
            .updateDonationCenter(event.donationCenter);
        final donationCenter = await donationCenterRepository
            .getDonationCenter(event.donationCenter.id ?? '');
        yield DonationCenterUpdateSuccess(donationCenter!);
      } catch (e) {
        yield DonationCenterOperationFailure();
      }
    }
    if (event is DonationCenterDelete) {
      yield DonationCenterLoading();
      try {
        await donationCenterRepository
            .deleteDonationCenter(event.donationCenter.id ?? "");
        // final donationCenters = await donationCenterRepository.getDonationCenters();
        yield DonationCenterDeleteSuccess();
      } catch (e) {
        yield DonationCenterOperationFailure();
      }
    }
  }
}
