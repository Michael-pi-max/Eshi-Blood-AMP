import 'dart:io';
import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/bloc/form_submission_status.dart';
import 'package:eshiblood/src/auth/bloc/signup_bloc.dart';
import 'package:eshiblood/src/auth/bloc/signup_event.dart';
import 'package:eshiblood/src/auth/bloc/signup_state.dart';
import 'package:eshiblood/src/auth/widgets/horizontal_divider.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:eshiblood/src/auth/widgets/text_input.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  void initState() {
    BlocProvider.of<SignUpBloc>(context).add(Reset());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
        backgroundColor: Color(0xFFD32026),
      ),
      body: RegisterWidget(),
    );
  }
}

class RegisterWidget extends StatelessWidget {
  RegisterWidget({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();

  var imagePicker;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            final formStatus = state.formStatus;
            if (formStatus is SubmissionFailed) {
              _showSnackBar(context, formStatus.errorMessage.toString());
            }
          },
        ),
        BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) async {
          final userRole =
              await context.read<AuthenticationBloc>().userRepository.getRole();
          final token = await context
              .read<AuthenticationBloc>()
              .userRepository
              .hasToken();

          // print(userRole);
          if (token) {
            if (userRole == 'user') {
              BlocProvider.of<SignUpBloc>(context).add(Reset());
              Navigator.of(context).pushNamed(RouteGenerator.homeScreen);
            }
          }
        })
      ],
      child: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileWidget(),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return TextInput(
                          prefixIcon: Icons.person,
                          labelText: 'First Name',
                          hintText: 'John',
                          onChanged: (value) => context
                              .read<SignUpBloc>()
                              .add(SignUpFirstNameChanged(firstName: value)),
                          onValidate: (value) => state.isFirstNameValid
                              ? null
                              : 'Invalid first name');
                    },
                  ),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return TextInput(
                        prefixIcon: Icons.person,
                        labelText: 'Last Name',
                        hintText: 'Doe',
                        onChanged: (value) => context
                            .read<SignUpBloc>()
                            .add(SignUpLastNameChanged(lastName: value)),
                        onValidate: (value) =>
                            state.isLastNameValid ? null : 'Invalid last name',
                      );
                    },
                  ),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return TextInput(
                        prefixIcon: Icons.phone,
                        labelText: 'PhoneNumber',
                        hintText: '09********',
                        keyboardType: TextInputType.phone,
                        onChanged: (value) => context
                            .read<SignUpBloc>()
                            .add(SignUpPhoneNumberChanged(phoneNumber: value)),
                        onValidate: (value) => state.isPhoneNumberValid
                            ? null
                            : 'Phone number start with 09********',
                      );
                    },
                  ),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return TextInput(
                        prefixIcon: Icons.mail,
                        labelText: 'Email',
                        hintText: 'johndoe@example.com',
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) => context
                            .read<SignUpBloc>()
                            .add(SignUpEmailChanged(email: value)),
                        onValidate: (value) => state.isEmailValid
                            ? null
                            : 'Use valid email address',
                      );
                    },
                  ),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return TextInput(
                        prefixIcon: Icons.lock,
                        labelText: 'Password',
                        hintText: '********',
                        onChanged: (value) => context
                            .read<SignUpBloc>()
                            .add(SignUpPasswordChanged(password: value)),
                        onValidate: (value) => state.isPasswordValid
                            ? null
                            : 'Password must be at least 4 characters',
                      );
                    },
                  ),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            width: 360,
                            height: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(25)),
                            child: Center(
                                child: Text(state.dateOfBirth == ''
                                    ? "2000-09-14"
                                    : state.dateOfBirth)),
                          ),
                        ),
                        onTap: () async {
                          var date = await showDatePicker(
                            context: context,
                            initialDate: DateTime(2004),
                            firstDate: DateTime(1970),
                            lastDate: DateTime(2004),
                          );
                          // print(date);
                          context.read<SignUpBloc>().add(
                              SignUpDateOfBirthChanged(
                                  dateOfBirth: date.toString().split(' ')[0]));
                        },
                      );
                    },
                  ),
                  GenderRadio(),
                  BloodTypeRadio(),
                  BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return state.formStatus is FormSubmitting
                          ? CircularProgressIndicator()
                          : RoundButton(
                              width: 360,
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  context
                                      .read<SignUpBloc>()
                                      .add(SignUpSubmitted());
                                }
                              },
                              text: "Sign up",
                              textColor: Colors.white,
                              color: Color(0xffd32026),
                            );
                    },
                  ),
                  HorizontalDivider(
                    label: 'Already have an account?',
                  ),
                  RoundButton(
                    text: 'Login',
                    width: 360,
                    textColor: Color(0xffd32026),
                    onPressed: () {
                      BlocProvider.of<SignUpBloc>(context).add(Reset());
                      Navigator.of(context)
                          .pushNamed(RouteGenerator.loginScreen);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}

class ProfileWidget extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Stack(
            alignment: AlignmentDirectional.bottomEnd,
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: () async {
                  // await _picker.pickImage(source: ImageSource.gallery)
                  // File image;
                  var imagePicker =
                      await _picker.pickImage(source: ImageSource.gallery);
                  context
                      .read<SignUpBloc>()
                      .add(SignUpProfileChanged(profile: imagePicker));
                  // await _picker.pickImage(source: ImageSource.gallery)
                },
                child: BlocBuilder<SignUpBloc, SignUpState>(
                  builder: (context, state) {
                    return state.profile == null
                        ? CircleAvatar(
                            radius: 71,
                            backgroundColor: Color(0xffd32026),
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage("assets/images/person.png"),
                            ),
                          )
                        : CircleAvatar(
                            radius: 70,
                            backgroundImage:
                                FileImage(File(state.profile.path)),
                          );
                  },
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(offset: Offset(1, 1))],
                  ),
                  child: BlocBuilder<SignUpBloc, SignUpState>(
                    builder: (context, state) {
                      return IconButton(
                        onPressed: () async {
                          print('aaa');
                          var imagePicker = await _picker.pickImage(
                              source: ImageSource.gallery);
                          context
                              .read<SignUpBloc>()
                              .add(SignUpProfileChanged(profile: imagePicker));

                          // if (imagePicker != null) {
                          //   final authBloc = BlocProvider.of<AuthBloc>(context);

                          //   authBloc.add(SignupEvent(profile: imagePicker));
                          // }
                        },
                        icon: Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                        iconSize: 15,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
            child: Text(
          "Profile",
          style: TextStyle(
            fontSize: 22,
          ),
        )),
      ],
    );
  }
}

class BloodTypeRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            margin: EdgeInsets.only(top: 10, bottom: 10),
            width: 350,
            // height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.red),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(width: 20,),
                Text("Blood Type"),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "A+",
                        ),
                        Text("A+")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "B+",
                        ),
                        Text("B+")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "AB+",
                        ),
                        Text("AB+")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "O+",
                        ),
                        Text("O+")
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "A-",
                        ),
                        Text("A-")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "B-",
                        ),
                        Text("B-")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "AB-",
                        ),
                        Text("AB-")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.bloodType,
                          onChanged: (value) => context.read<SignUpBloc>().add(
                              SignUpBloodTypeChanged(
                                  bloodType: value.toString())),
                          value: "O-",
                        ),
                        Text("O-")
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class GenderRadio extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width: 350,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.red),
              color: Colors.white,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // SizedBox(width: 20,),
                Text("Gender"),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.gender,
                          onChanged: (value) {
                            print(value);
                            context.read<SignUpBloc>().add(
                                SignUpGenderChanged(gender: value.toString()));
                          },
                          value: "Male",
                        ),
                        Text("Male")
                      ],
                    ),
                    Row(
                      children: [
                        Radio(
                          activeColor: Color(0xffd32026),
                          groupValue: state.gender,
                          onChanged: (value) {
                            print(value);
                            context.read<SignUpBloc>().add(
                                SignUpGenderChanged(gender: value.toString()));
                          },
                          value: "Female",
                        ),
                        Text("Female")
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
