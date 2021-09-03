
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
    if (event is RoleLoad) {
      yield RoleLoading();
      try {
        final roles = await roleRepository.getRoles();
        yield RolesLoadSuccess(roles);
      } catch (_) {
        yield RoleOperationFailure();
      }
    }

    if (event is RadioButtonSelected) {
      yield RadioButtonState(event.role);
    }

    if (event is RoleCreate) {
      try {
        await roleRepository.createRole(event.role);
        final roles = await roleRepository.getRoles();
        yield RolesLoadSuccess(roles);
      } catch (_) {
        yield RoleOperationFailure();
      }
    }

    if (event is RoleUpdate) {
      yield RoleLoading();
      try {
        await roleRepository.updateRole(event.role);
        final roles = await roleRepository.getRoles();
        yield RolesLoadSuccess(roles);
      } catch (_) {
        yield RoleOperationFailure();
      }
    }

    if (event is RoleDelete) {
      try {
        await roleRepository.deleteRole(event.role.id!);
        final roles = await roleRepository.getRoles();
        yield RolesLoadSuccess(roles);
      } catch (_) {
        yield RoleOperationFailure();
      }
    }
  }
}
