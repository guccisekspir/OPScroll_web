import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opscroll_web/blocs/bloc/scroll_bloc.dart';
import 'package:opscroll_web/locator.dart';

class OpscrollWeb extends StatefulWidget {
  final List<Widget> onePageChildren;
  final Curve scrollCurve;
  final Duration scrollSpeed;
  final Axis scrollDirection;
  final PageController pageController;
  static const MethodChannel _channel = MethodChannel('opscroll_web');

  const OpscrollWeb(
      {Key? key,
      required this.onePageChildren,
      required this.pageController,
      this.scrollCurve = Curves.easeIn,
      this.scrollSpeed = const Duration(milliseconds: 900),
      this.scrollDirection = Axis.vertical})
      : super(key: key);

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  @override
  State<OpscrollWeb> createState() => _OpscrollWebState();
}

class _OpscrollWebState extends State<OpscrollWeb> {
  late ScrollBloc scrollBloc;
  late PageController pageController;

  @override
  void initState() {
    // TODO: implement initState
    setupLocator();
    pageController = widget.pageController;
    scrollBloc = getIt<ScrollBloc>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<ScrollBloc, ScrollState>(
      bloc: scrollBloc,
      listener: (context, state) {
        if (state is ScrollToNextPage) {
          if (pageController.page!.toInt() ==
              widget.onePageChildren.length - 1) {
            debugPrint("*-*-* Last Page,will not scroll to next *-*-*");
          } else {
            pageController.nextPage(
                duration: widget.scrollSpeed, curve: widget.scrollCurve);
            setState(() {});
          }
        } else if (state is ScrollToPreviousPage) {
          debugPrint(pageController.page!.toInt().toString());
          if (!(pageController.page!.toInt() == 0)) {
            pageController.previousPage(
                duration: widget.scrollSpeed, curve: widget.scrollCurve);
          } else {
            debugPrint("*-*-* First Page,will not scroll to previous *-*-*");
          }
        }
      },
      child: Listener(
        onPointerSignal: (event) {
          // User scroll values listen in there
          // if PointerScrollEvent [scrollDelta.dy] is negative
          // it is meaning of user scroll to UP
          // so we want to yield state [ScrollToNextPage].
          if (event is PointerScrollEvent) {
            scrollBloc.add(ScrollStart(
                scrollStartDateTime: DateTime.now(),
                isUp: event.scrollDelta.dy.isNegative));
          }
        },
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: pageController,
            scrollDirection: widget.scrollDirection,
            allowImplicitScrolling: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            physics: const NeverScrollableScrollPhysics(),
            children: widget.onePageChildren,
          ),
        ),
      ),
    );
  }
}
