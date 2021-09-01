import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/models/user_model.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SecureStorage userRepository;

  AuthenticationBloc({required this.userRepository})
      : super(AuthenticationUninitialized());

  @override
  Stream<AuthenticationState> mapEventToState(event) async* {
    if (event is WelcomeScreenCompleted) {
      yield* _initStartup(null);
    } else if (event is LoggedIn) {
      yield* _loggedIn(event);
    } else if (event is LoggedOut) {
      yield* _loggedOut(event);
    }
  }

  Stream<AuthenticationState> _initStartup(dynamic user) async* {
    final hasToken = await userRepository.hasToken();

    if (!hasToken) {
      yield AuthenticationUnauthenticated();
      return;
    }
    // print(user);
    yield AuthenticationAuthenticated(user: user);
  }

  Stream<AuthenticationState> _loggedIn(LoggedIn event) async* {
    yield AuthenticationLoading();

    await userRepository.persistPhoneRoleAndToken(
        event.phoneNumber!, event.role, event.token!, event.id!);

    yield* _initStartup(event.user!);
  }

  Stream<AuthenticationState> _loggedOut(LoggedOut event) async* {
    yield AuthenticationLoggingOut();
    await userRepository.deleteAll();
  }
}
