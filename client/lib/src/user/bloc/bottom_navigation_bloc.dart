import 'package:eshiblood/src/auth/bloc/password_visibility_state.dart';
import 'package:eshiblood/src/user/bloc/bottom_navigation_event.dart';
import 'package:eshiblood/src/user/bloc/bottom_navigation_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ButtomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  ButtomNavigationBloc() : super(BottomNavigationState());

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is ClickBottomNavigationEvent) {
      yield state.copyWith(currentIndex: event.currentIndex);
    }
  }
}
