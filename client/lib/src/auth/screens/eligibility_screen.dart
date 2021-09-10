import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/widgets/app_button.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EligibilityNoticeScreen extends StatelessWidget {
  final EligibilityItems eligibilityItems = EligibilityItems();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: Color(0xFFD32026),
                  expandedHeight: 235.0,
                  title: Text(''),
                  floating: true,
                  // Pinned ?
                  // pinned: true,
                  leading: Container(),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      'assets/images/eligibility_notice.png',
                    ),
                  ),
                ),
                SliverFixedExtentList(
                  itemExtent: 128,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            Text(
                              """To insure the safety of donor and recipients all volunteer donors must be evaluated to determine their eligibility to give blood.""",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Text(
                              """This check up is solely used to determine that you are able to create an account""",
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: 1,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return Column(
                        children: [
                          buildListTile(index, eligibilityItems),
                          Divider(
                            color: Colors.grey,
                            indent: 30.0,
                            endIndent: 30.0,
                            height: 4.0,
                          ),
                        ],
                      );
                    },
                    childCount: eligibilityItems.eligibilityItems.length,
                  ),
                ),
                SliverFixedExtentList(
                  itemExtent: 50,
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return (state is AuthenticationAuthenticated)?null:
                      RoundButton(
                        color: Color(0xFFD32026),
                        textColor: Colors.white,
                        text: 'Proceed to check up',
                        padding: 0.0,
                        borderCurve: 5,
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed(RouteGenerator.registrationScreen);
                        },
                      );
                    },
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Widget buildListTile(int index, EligibilityItems eligibileItems) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20.0),
    margin: EdgeInsets.all(10.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            Text(
              '${eligibileItems.eligibilityItems[index].index + 1}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Color(0xFFD32026),
              ),
            ),
            SizedBox(
              width: 8.0,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    """${eligibileItems.eligibilityItems[index].title}""",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    """${eligibileItems.eligibilityItems[index].description}""",
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class EligibilityItems {
  List<EligibilityItem> eligibilityItems = [
    EligibilityItem(
      index: 0,
      title: 'Be in good general health and feeling well',
      description:
          """Healthy means that you feel well and can perform normal activities. If you have a chronic condtion such as diabets, healthy means that you are being treated and the condition is undercontrol""",
    ),
    EligibilityItem(
      index: 1,
      title: 'Be at least 18 years old',
      description:
          """If allowed by state law, 16 years old may give with parental consent""",
    ),
    EligibilityItem(
      index: 2,
      title: 'Weight atleast 110 pounds',
      description:
          """Additional weight requirments apply for donors 18 years old or younder and all highschool donors""",
    ),
    EligibilityItem(
      index: 3,
      title:
          'Is not exposed to any kind of tattoos on body within the past 6 months',
      description:
          """If you have a tattoo in the specified duration, please create an account at the appropriate time""",
    ),
    EligibilityItem(
      index: 4,
      title: 'Is pregnant or have been pregnant within the past year',
      description:
          """If you are pregenant or have been pregnant in the specified time, please create an account at the appropriate tune""",
    ),
    EligibilityItem(
      index: 5,
      title:
          'Is not exposed to any kind of tattoos on body within the past 6 months',
      description:
          """If you have a tattoo in the specified duration, please create an account at the appropriate time""",
    ),
    EligibilityItem(
      index: 6,
      title: 'Is pregnant or have been pregnant within the past year',
      description:
          """If you are pregenant or have been pregnant in the specified time, please create an account at the appropriate tune""",
    ),
    // EligibilityItem(
    //   index: 5,
    //   title:
    //       'Is not exposed to any kind of tattoos on body within the past 6 months',
    //   description:
    //       """If you have a tattoo in the specified duration, please create an account at the appropriate time""",
    // ),
    // EligibilityItem(
    //   index: 6,
    //   title: 'Is pregnant or have been pregnant within the past year',
    //   description:
    //       """If you are pregenant or have been pregnant in the specified time, please create an account at the appropriate tune""",
    // ),
    // EligibilityItem(
    //   index: 5,
    //   title:
    //       'Is not exposed to any kind of tattoos on body within the past 6 months',
    //   description:
    //       """If you have a tattoo in the specified duration, please create an account at the appropriate time""",
    // ),
    // EligibilityItem(
    //   index: 6,
    //   title: 'Is pregnant or have been pregnant within the past year',
    //   description:
    //       """If you are pregenant or have been pregnant in the specified time, please create an account at the appropriate tune""",
    // ),
  ];
}

class EligibilityItem {
  int index = 0;
  String title;
  String description;

  EligibilityItem(
      {required this.index, required this.title, required this.description});
}
