// import 'package:flutter/material.dart';

// class PageFlipBuilder extends StatefulWidget {
//   final WidgetBuilder frontBuilder;
//   final WidgetBuilder backBuilder;

//   const PageFlipBuilder(
//       {Key? key, required this.frontBuilder, required this.backBuilder})
//       : super();
//   @override
//   PageFlipBuilderState createState() => PageFlipBuilderState();
// }

// class PageFlipBuilderState extends State<PageFlipBuilder>
//     with SingleTickerProviderStateMixin {
//   bool _showFrontSide = true;
//   late final AnimationController _controller;
//   @override
//   void initState() {
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(microseconds: 500),
//     );
//     _controller.addStatusListener(_updateStatus);
//     _controller.addListener(() {
//       print('Value: ${_controller.value}');
//     });
//     super.initState();
//   }

//   void _updateStatus(AnimationStatus status) {
//     if (status == AnimationStatus.completed ||
//         status == AnimationStatus.dismissed) {
//       setState(
//         () => _showFrontSide = !_showFrontSide,
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _controller.removeStatusListener((status) {
//       _updateStatus(status);
//     });
//     _controller.dispose();
//     super.dispose();
//   }

//   void flip() {
//     if (_showFrontSide) {
//       _controller.forward();
//     } else {
//       _controller.reverse();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return widget.frontBuilder(context);
//   }
// }
