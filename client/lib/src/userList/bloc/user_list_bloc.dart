import 'package:eshiblood/src/auth/models/user_model.dart';
import 'package:eshiblood/src/userList/bloc/user_list_event.dart';
import 'package:eshiblood/src/userList/bloc/user_list_state.dart';
import 'package:eshiblood/src/userList/repository/user_list_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListBloc extends Bloc<UserEvent, UserListState> {
  final UserListRepository userListRepository;

  UserListBloc({required this.userListRepository})
      : super(UserListStateInitial());

  @override
  Stream<UserListState> mapEventToState(UserEvent event) async* {
    if (event is UserListEvent) {
      try {
        final List<User> users = await userListRepository.getUserList();
        if (users == []) {
          yield UserListStateLoading();
        } else {
          yield UserListStateLoaded(users: users);
        }
      } catch (e) {
        yield UserListStateError(error: e.toString());
      }
    }

    if (event is UpdateUserEvent) {
      try {
        print("${event.userId!} ${event.roleId!}");
        await userListRepository.updateUser(event.userId!, event.roleId!);
        yield UpdateUserRole();
      } catch (e) {}
    }
  }
}
