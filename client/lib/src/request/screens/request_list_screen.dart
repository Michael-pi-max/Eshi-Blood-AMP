import 'package:eshiblood/src/auth/bloc/auth_bloc.dart';
import 'package:eshiblood/src/auth/bloc/auth_state.dart';
import 'package:eshiblood/src/auth/repository/secure_storage.dart';
import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/request/bloc/request_bloc.dart';
import 'package:eshiblood/src/request/bloc/request_event.dart';
import 'package:eshiblood/src/request/bloc/request_state.dart';
import 'package:eshiblood/src/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RequestListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<RequestBloc>(context).add(RequestsLoad());
    return Scaffold(
      body: BlocListener<RequestBloc, RequestState>(
        listener: (context, state) {
          if (state is RequestAccepted) {
            Navigator.of(context).pushNamed(RouteGenerator.requestList);
          }
        },
        child: BlocBuilder<RequestBloc, RequestState>(
          builder: (context, state) {
            return (state is RequestsLoadSuccess)
                ? Container(
                    margin: EdgeInsets.all(12.0),
                    padding: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.0),
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Colors.grey,
                        )
                      ],
                    ),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        BlocProvider.of<RequestBloc>(context).add(
                          RequestsLoad(),
                        );
                      },
                      child: ListView.builder(
                        itemCount: state.requests.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _buildRequestTile(
                            context,
                            index: index,
                            request: state.requests[index],
                          );
                        },
                      ),
                    ),
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          },
        ),
      ),
    );
  }

  _buildRequestTile(
    context, {
    index,
    request,
  }) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return (state is AuthenticationAuthenticated)
            ? Container(
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(10),
                child: (state.user?.role["privileges"][2]["permissions"]
                        .contains("read"))
                    ? Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: Color(0xFFD32026),
                                child: Text('${request.bloodType}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${request.unitsNeeded} Units needed',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      style: DefaultTextStyle.of(context).style,
                                      children: <TextSpan>[
                                        TextSpan(
                                            text: '${request.totalDonations} ',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFFD32026))),
                                        TextSpan(text: 'total donation'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text('${request.status}',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                      ))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              state.user?.role["privileges"][2]["permissions"]
                                      .contains("update")
                                  ? (state.user?.appointed)
                                      ? Center(
                                          child: Container(
                                            child: Column(
                                              children: [
                                                RoundButton(
                                                  color: Colors.white,
                                                  text:
                                                      'You have pending appointment',
                                                  textColor: Color(0xFFd32026),
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pushNamed(
                                                            RouteGenerator
                                                                .homeScreen);
                                                  },
                                                  borderCurve: 10.0,
                                                  width: 40,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : DateTime.fromMillisecondsSinceEpoch(int.parse(
                                                          state.user!.lastDonation ??
                                                              '1623501622005'))
                                                      .add(const Duration(
                                                          days: 90))
                                                      .difference(
                                                          DateTime.now())
                                                      .inDays >
                                                  0 &&
                                              DateTime.fromMillisecondsSinceEpoch(
                                                          int.parse(state.user!
                                                                  .lastDonation ??
                                                              '1623501622005'))
                                                      .add(const Duration(days: 90))
                                                      .difference(DateTime.now())
                                                      .inDays <
                                                  90
                                          ? Container(
                                              child: Text(
                                                '${DateTime.fromMillisecondsSinceEpoch(int.parse(state.user!.lastDonation ?? '1623501622005')).add(const Duration(days: 90)).difference(DateTime.now()).inDays} days left to donate.',
                                              ),
                                            )
                                          : InkWell(
                                              onTap: () async {
                                                BlocProvider.of<RequestBloc>(
                                                        context)
                                                    .add(
                                                        RequestAccept(request));
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(8),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: Colors.red,
                                                  ),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.check),
                                                    Text(
                                                      'Accept',
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                  : Container(
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(),
                                      child: Row(
                                        children: [
                                          Icon(Icons.block),
                                          Text(
                                            " Can't accept request. Contact your admin.",
                                          ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey[300],
                          ),
                        ],
                      )
                    : Center(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(),
                          child: Row(
                            children: [
                              Icon(Icons.block),
                              Text(
                                " Can't view requests. Contact your admin.",
                              ),
                            ],
                          ),
                        ),
                      ),
              )
            : Center(
                child: CircularProgressIndicator(),
              );
      },
    );
  }
}
