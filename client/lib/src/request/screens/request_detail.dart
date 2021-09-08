import 'package:eshiblood/src/auth/widgets/round_button.dart';
import 'package:eshiblood/src/request/model/request.dart';
import 'package:eshiblood/src/utilities/constants.dart';
import 'package:flutter/material.dart';
import "package:percent_indicator/circular_percent_indicator.dart";
import 'dart:math' as math;

class RequestDetail extends StatelessWidget {
  final Request request;

  RequestDetail({required this.request});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Color(0xFFD32026),
              expandedHeight: 200.0,
              title: Text(''),
              floating: true,
              leading: Container(),
              flexibleSpace: _MyAppSpace(request),
              pinned: true,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Units Needed',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      subtitle: Text(
                                        '${this.request.unitsNeeded}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                    // Row(
                                    //     mainAxisAlignment:
                                    //         MainAxisAlignment.spaceBetween,
                                    //     children: <Widget>[
                                    //       Text(
                                    //         'Units Needed',
                                    //         style: TextStyle(fontSize: 16),
                                    //       ),
                                    //       Text(
                                    //         '${this.request.unitsNeeded}',
                                    //         style: TextStyle(fontSize: 16),
                                    //       ),
                                    //     ]),
                                  ],
                                ),
                              ),
                              Divider(thickness: 1.0, color: Colors.grey[300]),

                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'Reason',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      '${this.request.reason}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),
                              // Divider(thickness: 1.0, color: Color(0xFFD32026)),
                              Divider(thickness: 1.0, color: Colors.grey[300]),

                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'Blood Type',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      '${this.request.bloodType}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),

                              Divider(thickness: 1.0, color: Colors.grey[300]),
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Column(children: <Widget>[
                                  ListTile(
                                    title: Text(
                                      'Status',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    subtitle: Text(
                                      '${this.request.status}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ]),
                              ),

                              // Expanded(
                              //   child: ListView.builder(
                              //     itemCount: request.donors!.length,
                              //     itemBuilder: (context, index) {
                              //       return Text('hey');
                              //     },
                              //   ),
                              // ),

                              // Padding(
                              //   padding: const EdgeInsets.all(20.0),
                              //   child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //       children: <Widget>[
                              //         Text(
                              //           'Status',
                              //           style: TextStyle(fontSize: 16),
                              //         ),
                              //         Text(
                              //           '${this.request.status}',
                              //           style: TextStyle(fontSize: 16),
                              //         ),
                              //       ]),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
                childCount: 1,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                child: Text(
                  'Participants',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: NetworkImage(
                                '${Constants.imageBaseUrl}images/users/${request.donors?[index].image}'),
                          ),
                          title: Text(
                              '${request.donors?[index].fistname ?? "Rediet"} ${request.donors?[index].lastname ?? "Atnafu"} '),
                          subtitle:
                              Text('${request.donors?[index].phoneNumber}'),
                        ),

                        // Text('${request.donors?[index]["firstName"]}'),
                        Divider(),
                      ],
                    ),
                  );
                },
                childCount: request.donors!.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyAppSpace extends StatelessWidget {
  final request;

  _MyAppSpace(this.request);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final settings = context
          .dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>();
      final deltaExtent = settings!.maxExtent - settings.minExtent;
      final t =
          (1.0 - (settings.currentExtent - settings.minExtent) / deltaExtent)
              .clamp(0.0, 1.0) as double;
      final fadeStart = math.max(0.0, 1.0 - kToolbarHeight / deltaExtent);
      final fadeEnd = 1.0;
      final opacity = 1.0 - Interval(fadeStart, fadeEnd).transform(t);
      return Stack(
        children: [
          Opacity(
            opacity: 1 - opacity,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Request',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        )),
                    CircularPercentIndicator(
                      backgroundColor: Color(0xFFD32026),
                      radius: 40.0,
                      lineWidth: 4.0,
                      percent: request.totalDonations / request.unitsNeeded,
                      center: Text(
                        '${(request.totalDonations / request.unitsNeeded) * 100}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      progressColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Opacity(
            opacity: opacity,
            child: Center(
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        direction: Axis.vertical,
                        children: [
                          CircularPercentIndicator(
                            backgroundColor: Color(0xFFD32026),
                            radius: 80.0,
                            lineWidth: 8.0,
                            percent:
                                request.totalDonations / request.unitsNeeded,
                            center: Text(
                                '${(request.totalDonations / request.unitsNeeded) * 100}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                )),
                            progressColor: Colors.white,
                          ),
                          Text(
                            'Progress',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      );
    });
  }
}
