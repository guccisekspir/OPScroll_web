import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opscroll_web/blocs/bloc/scroll_bloc.dart';
import 'package:opscroll_web/locator.dart';

/// [onePageChildren] is your One Page widgets. This widget size is initial Full device screen size.
/// You must to create your one page widget's inside, responsive in your code.

/// [scrollCurve] is scrolling Curve value for [PageController]. Try every Curves!
/// and find your suitable scroll animations for your OPS.

/// [scrollSpeed] is scrolling duration for your OPS.
/// You should give less duration for speedy scrolling or vice versa

/// [scrollDirection] is your PageView scrolling axis.

/// [PageController] is OPS controller.

/// [isFloatingButtonActive] is allow to scrolling by Floating Action Buttons
/// also you can change the color variable with
/// [floatingButtonSplashColor] [floatingButtonBackgroundColor]

/// [isTouchScrollingActive] is allows to scrolling by Tapping.
/// Be careful if you are using Gesture Detector in your [onePageChildren]
/// Should look at https://flutter.dev/docs/development/ui/advanced/gestures#gesture-disambiguation

/// [onTapGesture] you can define your own onTap functions with this callback.
/// default function is scroll to next page.

class OpscrollWeb extends StatefulWidget {
  final List<Widget> onePageChildren;
  final Curve scrollCurve;
  final Duration scrollSpeed;
  final Axis scrollDirection;
  final PageController pageController;
  //Floating Action Button
  final bool isFloatingButtonActive;
  final Color floatingButtonSplashColor;
  final Color floatingButtonBackgroundColor;
  //Scrolling Options
  final bool isTouchScrollingActive;
  final VoidCallback? onTapGesture;
  final bool isFadingScroll;

  static const MethodChannel _channel = MethodChannel('opscroll_web');

  const OpscrollWeb(
      {Key? key,
      required this.onePageChildren,
      required this.pageController,
      this.onTapGesture,
      this.floatingButtonBackgroundColor = Colors.grey,
      this.floatingButtonSplashColor = Colors.grey,
      this.isFloatingButtonActive = false,
      this.isTouchScrollingActive = false,
      this.isFadingScroll = false,
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

class _OpscrollWebState extends State<OpscrollWeb>
    with SingleTickerProviderStateMixin {
  late ScrollBloc scrollBloc;
  late PageController pageController;

  AnimationController? animationController;

  @override
  void initState() {
    // TODO: implement initState
    setupLocator();
    if (widget.isFadingScroll) {
      animationController = AnimationController(
          vsync: this,
          duration: Duration(milliseconds: widget.scrollSpeed.inMilliseconds))
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
            animationController!.reverse();
          }
        });
      animationController!.addListener(() {
        setState(() {});
      });
    }
    pageController = widget.pageController;

    scrollBloc = getIt<ScrollBloc>();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      setState(() {
        isInitialized = true;
      });
    });
    super.initState();
  }

  /// We need initialized information because of PageView
  /// Page controller cant access while PageView not builded.
  /// We have to ensure about PageView builded before using [pageController]
  bool isInitialized = false;

  int currentPageIndex = 0;

  Future<void> fadeScroll(bool isNext) async {
    animationController!.forward();
    setState(() {
      isNext ? currentPageIndex++ : currentPageIndex--;
    });

    await Future.delayed(
        Duration(milliseconds: (widget.scrollSpeed.inMilliseconds).toInt()));
    isNext
        ? pageController.nextPage(
            duration: const Duration(milliseconds: 10),
            curve: widget.scrollCurve)
        : pageController.previousPage(
            duration: const Duration(milliseconds: 10),
            curve: widget.scrollCurve);
  }

  void defaultScroll(bool isNext) {
    if (isNext) {
      pageController.nextPage(
          duration: widget.scrollSpeed, curve: widget.scrollCurve);
      setState(() {
        currentPageIndex++;
      });
    } else {
      if (!(pageController.page!.toInt() == 0)) {
        pageController.previousPage(
            duration: widget.scrollSpeed, curve: widget.scrollCurve);
        setState(() {
          currentPageIndex--;
        });
      } else {
        debugPrint("*-*-* First Page,will not scroll to previous *-*-*");
      }
    }
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
            if (widget.isFadingScroll) {
              fadeScroll(true);
            } else {
              defaultScroll(true);
            }
          }
        } else if (state is ScrollToPreviousPage) {
          debugPrint(pageController.page!.toInt().toString());
          if (widget.isFadingScroll) {
            fadeScroll(false);
          } else {
            defaultScroll(false);
          }
        }
      },
      child: Listener(
        onPointerSignal: (event) {
          /// User scroll values listen in there
          /// if PointerScrollEvent [scrollDelta.dy] is negative
          /// it is meaning of user scroll to UP
          /// so we want to yield state [ScrollToNextPage].
          if (event is PointerScrollEvent) {
            scrollBloc.add(ScrollStart(
                scrollStartDateTime: DateTime.now(),
                isUp: event.scrollDelta.dy.isNegative));
          }
        },
        child: Scaffold(
          floatingActionButton: isInitialized
              ? widget.isFloatingButtonActive
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        currentPageIndex != 0
                            ? FloatingActionButton(
                                backgroundColor: widget
                                    .floatingButtonBackgroundColor
                                    .withOpacity(0.3),
                                splashColor: widget.floatingButtonSplashColor,
                                onPressed: () {
                                  if (widget.isFadingScroll) {
                                    fadeScroll(false);
                                  } else {
                                    defaultScroll(false);
                                  }
                                },
                                child: const Icon(Icons.arrow_upward_sharp),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 10,
                        ),
                        currentPageIndex != widget.onePageChildren.length - 1
                            ? FloatingActionButton(
                                backgroundColor: widget
                                    .floatingButtonBackgroundColor
                                    .withOpacity(0.3),
                                splashColor: widget.floatingButtonSplashColor,
                                onPressed: () {
                                  if (widget.isFadingScroll) {
                                    fadeScroll(true);
                                  } else {
                                    defaultScroll(true);
                                  }
                                },
                                child: const Icon(
                                  Icons.arrow_downward_sharp,
                                ))
                            : const SizedBox(),
                      ],
                    )
                  : const SizedBox()
              : const SizedBox(),
          body: GestureDetector(
            onVerticalDragUpdate: (details) {
              scrollBloc.add(ScrollStart(
                  scrollStartDateTime: DateTime.now(),
                  isUp: !details.delta.dy.isNegative));
            },
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Opacity(
                opacity:
                    widget.isFadingScroll ? 1 - animationController!.value : 1,
                child: PageView(
                  controller: pageController,
                  scrollDirection: widget.scrollDirection,
                  allowImplicitScrolling: true,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  physics: const NeverScrollableScrollPhysics(),
                  children: widget.onePageChildren
                      .map((e) => GestureDetector(
                            onTap: widget.onTapGesture ??
                                () {
                                  if (widget.isTouchScrollingActive) {
                                    if (widget.isFadingScroll) {
                                      fadeScroll(true);
                                    } else {
                                      defaultScroll(true);
                                    }
                                  }
                                },
                            child: e,
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
