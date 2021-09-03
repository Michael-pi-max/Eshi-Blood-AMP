import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:eshiblood/src/donation_center/models/donation_center.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'form_donation_center_event.dart';
part 'form_donation_center_state.dart';

class FormDonationCenterBloc
    extends Bloc<FormDonationCenterEvent, FormDonationCenterState> {
  FormDonationCenterBloc() : super(FormDonationCenterState());

  @override
  Stream<FormDonationCenterState> mapEventToState(
    FormDonationCenterEvent event,
  ) async* {
    if (event is NameChange) {
      if (event.name.length != 0) {
        yield state.copyWith(name: event.name);
      } else {
        yield DonationCenterFormNameError();
      }
    }

    if (event is StateChange) {
      if (state.isStateValid) {
        yield state.copyWith(state: event.state);
      } else {
        yield DonationCenterFormStateError();
      }
    }

    if (event is WeredaChange) {
      if (state.isWeredaValid) {
        yield state.copyWith(wereda: event.wereda);
      } else {
        yield DonationCenterFormWeredaError();
      }
    }

    if (event is CityChange) {
      if (state.isCityValid) {
        yield state.copyWith(city: event.city);
      } else {
        yield DonationCenterFormCityError();
      }
    }

    if (event is startDateChange) {
      if (state.isStartDateValid == true) {
        // print(event.startDate);
        yield state.copyWith(startDate: event.startDate);
      } else {
        yield DonationCenterFormStartDateError();
      }
    }

    if (event is endDateChange) {
      yield state.copyWith(endDate: event.endDate);
      if (state.isEndDateValid == false) {
        yield DonationCenterFormEndDateError();
      }
    }
    if (event is DonationCenterFormSubmit) {
      yield DonationCenterFormSubmitPending();

      if (state.formValid()) {
        yield state;
        sleep(const Duration(seconds: 1));
        yield DonationCenterFormSubmitSuccess();
      } else {
        sleep(const Duration(seconds: 1));
        yield DonationCenterFormFailed("Form Inputs invalid");
      }
    }
  }
}
