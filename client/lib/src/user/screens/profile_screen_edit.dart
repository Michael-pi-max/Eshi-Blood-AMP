import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_event.dart';
import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/auth/bloc/signup_bloc.dart';
import 'package:eshiblood/src/auth/bloc/signup_event.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/user/bloc/update_bloc.dart';
import 'package:eshiblood/src/user/bloc/update_event.dart';
import 'package:eshiblood/src/user/bloc/update_state.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eshiblood/src/auth/widgets/text_input.dart';

class EditUserDetails extends StatefulWidget {
  @override
  _EditUserDetailsState createState() => _EditUserDetailsState();
}

class _EditUserDetailsState extends State<EditUserDetails> {
  @override
  void initState() {
    BlocProvider.of<SignUpBloc>(context).add(Reset());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffd32026),
        title: Text('Update Profile'),
      ),
      body: EditUserWidget(),
    );
  }
}

class EditUserWidget extends StatelessWidget {
  EditUserWidget({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<UpdateBloc>(context)..add(UpdateOut());
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(10),
        child: ListView(
          scrollDirection: Axis.vertical,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<UpdateBloc, UpdateState>(
                  builder: (context, state) {
                    return TextInput(
                      prefixIcon: Icons.phone,
                      labelText: 'PhoneNumber',
                      hintText: '09********',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) => context
                          .read<UpdateBloc>()
                          .add(UpdatePhoneNumberChanged(phoneNumber: value)),
                      onValidate: (value) => state.isPhoneNumberValid
                          ? null
                          : 'Phone number start with 09********',
                    );
                  },
                ),
                BlocBuilder<UpdateBloc, UpdateState>(
                  builder: (context, state) {
                    return (state.formStatus is FormSubmitting)
                        ? CircularProgressIndicator()
                        : RoundButton(
                            text: 'Update Profile',
                            width: 360,
                            textColor: Color(0xffd32026),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                print("AAAAAAAAAAA");
                                BlocProvider.of<UpdateBloc>(context)
                                    .add(UpdateSubmitted());

                                // BlocProvider.of<AuthenticationBloc>(context)
                                //     .add(LoggedOut());

                                Navigator.of(context).popAndPushNamed(
                                    RouteGenerator.welcomeScreen);
                              }
                              // BlocProvider.of<LoginBloc>(context).add(LoginSubmitted());
                            },
                          );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
