import 'package:bloc_test/bloc_test.dart';
import 'package:eshiblood/src/admin/bloc/role_bloc.dart';
import 'package:eshiblood/src/admin/bloc/role_event.dart';
import 'package:eshiblood/src/admin/bloc/role_state.dart';
import 'package:eshiblood/src/admin/model/role_model.dart';
import 'package:eshiblood/src/admin/repositories/role_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRoleRepository extends Mock implements RoleRepository {}

void main() {
  MockRoleRepository mockRoleRepository = MockRoleRepository();
  setUp(() {
    mockRoleRepository = MockRoleRepository();
  });
  group("Get Role", () {
    List<Role> roles = [
      Role(roleName: "", permissions: ["view", "create"], title: ["user"]),
      Role(roleName: "", permissions: ["view", "create"], title: ["user"])
    ];

    blocTest<RoleBloc, RoleState>("emits",
        build: () =>
            {when(mockRoleRepository.getRoles()).thenAnswer((_) async => roles); return RoleBloc(roleRepository: mockRoleRepository)},
            act: (bloc){bloc.add(RoleLoad());
            },
            expect: () => [
              RoleLoading(),
              RolesLoadSuccess(roles)
            ]
            );
  });
}
