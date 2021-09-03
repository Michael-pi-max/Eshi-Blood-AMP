import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/user/bloc/update_event.dart';
import 'package:eshiblood/src/user/bloc/update_state.dart';
import 'package:eshiblood/src/user/repository/user_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateBloc extends Bloc<UpdateEvent, UpdateState> {
  final UserProfileRepository userProfileRepository;
  UpdateBloc({required this.userProfileRepository})
      : super(UpdateState(phoneNumber: '0'));

  @override
  Stream<UpdateState> mapEventToState(UpdateEvent event) async* {
    if (event is UpdatePhoneNumberChanged) {
      yield state.copyWith(phoneNumber: event.phoneNumber);
    } else if (event is UpdateOut) {
      yield state.copyWith(password: '', phoneNumber: '');
    } else if (event is UpdateSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());
      print('---------------------From Update Bloc-------------------');
      try {
        await userProfileRepository.updateProfile(state.phoneNumber);
        print("Yaaaaaaaaaaaaaayyyyy");
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        print(e);
      }
    } else if (event is DeleteButtonClicked) {
      try {
        await userProfileRepository.deleteUser(event.id!);
        print("Deleted user successfully");
        yield state.copyWith(formStatus: InitialFormStatus());
      } catch (e) {}
    }
  }
}
