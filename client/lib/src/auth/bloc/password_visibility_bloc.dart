import 'package:eshiblood/src/auth/bloc/password_visibility_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum ToggleEvent { toggleVisibility }

class ToggleBloc extends Bloc<ToggleEvent, VisibilityState> {
  ToggleBloc() : super(VisibilityState());

  @override
  Stream<VisibilityState> mapEventToState(ToggleEvent event) async* {
    switch (event) {
      case ToggleEvent.toggleVisibility:
        yield state.isVisible == true
            ? VisibilityState(isVisible: false)
            : VisibilityState(isVisible: true);
        break;
    }
  }
}
