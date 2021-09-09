import 'package:eshiblood/src/appointment/bloc/appointment_bloc.dart';
import 'package:eshiblood/src/appointment/data_provider/appointment_data_provider.dart';
import 'package:eshiblood/src/appointment/repository/appointment_repository.dart';
import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/login_bloc.dart';
import 'package:eshiblood/src/auth/bloc/signup_bloc.dart';
import 'package:eshiblood/src/auth/data_provider/auth_data_provider.dart';
import 'package:eshiblood/src/auth/repository/auth_repository.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/donation_center/bloc/donation_center_bloc.dart';
import 'package:eshiblood/src/donation_center/bloc/form_donation_center_bloc.dart';
import 'package:eshiblood/src/donation_center/data_provider/donation_center_data.dart';
import 'package:eshiblood/src/request/bloc/request_bloc.dart';
import 'package:eshiblood/src/request/data_providers/request_data_provider.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/request/request_repository/request_repository.dart';
import 'package:eshiblood/src/role_management/bloc/role_bloc.dart';
import 'package:eshiblood/src/role_management/data_provider/role_data_provider.dart';
import 'package:eshiblood/src/role_management/repository/role_repository.dart';
import 'package:eshiblood/src/user/bloc/update_bloc.dart';
import 'package:eshiblood/src/user/bloc/update_event.dart';
import 'package:eshiblood/src/user/data_provider/user_data_provider.dart';
import 'package:eshiblood/src/user/repository/user_repository.dart';
import 'package:eshiblood/src/user/screens/donation_card_screen.dart';
import 'package:eshiblood/src/user/screens/donation_history_screen.dart';
import 'package:eshiblood/src/userList/bloc/user_list_bloc.dart';
import 'package:eshiblood/src/userList/data_provider/user_list_provider.dart';
import 'package:eshiblood/src/userList/repository/user_list_repository.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_flip_builder/page_flip_builder.dart';

import 'donation_center/repository/donation_center_repository.dart';

class App extends StatelessWidget {
  final authRepo = AuthRepository(authProvider: AuthProvider());
  final roleRepository = RoleRepository(dataProvider: RoleDataProvider());
  final requestRepo = RequestRepository(dataProvider: RequestDataProvider());
  final appointmentRepository =
      AppointmentRepository(AppointmentDataProvider());
  var donationCenterRepository =
      DonationCenterRepository(dataProvider: DonationCenterDataProvider());
  final userRepository = SecureStorage();
  final userListRepository =
      UserListRepository(userListProvider: UserListProvider());
  final updateRepository =
      UserProfileRepository(userProfileProvider: UserProfileProvider());
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          DonationCenterRepository(dataProvider: DonationCenterDataProvider()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              userRepository: userRepository,
            ),
          ),
          BlocProvider(
            create: (context) => SignUpBloc(
                authRepo: authRepo,
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context)),
          ),
          BlocProvider(
            create: (context) => LoginBloc(
                authRepository: authRepo,
                authenticationBloc:
                    BlocProvider.of<AuthenticationBloc>(context)),
          ),
          BlocProvider(
            create: (context) => RequestBloc(
              requestRepository: requestRepo,
            ),
          ),
          BlocProvider(
            create: (context) => AppointmentBloc(
              appointmentRepository: appointmentRepository,
            ),
          ),
          BlocProvider<DonationCenterBloc>(
            create: (BuildContext context) => DonationCenterBloc(
                donationCenterRepository: donationCenterRepository),
          ),
          BlocProvider<FormDonationCenterBloc>(
            create: (BuildContext context) => FormDonationCenterBloc(),
          ),
          BlocProvider(
            create: (context) => RoleBloc(roleRepository: roleRepository),
          ),
          BlocProvider(
            create: (context) =>
                UserListBloc(userListRepository: userListRepository),
          ),
          BlocProvider(
              create: (context) =>
                  UpdateBloc(userProfileRepository: updateRepository)
                    ..add(UpdateOut()))
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: RouteGenerator.welcomeScreen,
          onGenerateRoute: RouteGenerator.generateRoute,
        ),
      ),
    );
  }
}
