
import 'package:eshiblood/src/role_management/bloc/role_event.dart';
import 'package:eshiblood/src/role_management/bloc/role_state.dart';
import 'package:eshiblood/src/role_management/repository/role_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  final RoleRepository roleRepository;

  RoleBloc({required this.roleRepository})
      : assert(roleRepository != null),
        super(RoleInitial());

  @override
  Stream<RoleState> mapEventToState(RoleEvent event) async* {
    
  }
}
