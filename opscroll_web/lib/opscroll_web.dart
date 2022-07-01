import 'dart:async';

import 'package:flutter/animation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:opscroll_web/circleAnimation.dart';
import 'package:opscroll_web/dropAnimation.dart';

import 'package:opscroll_web/scrollState.dart';

enum ScrollingAnimationOptions { Fading, Drop, Circle, Default }

/// [Scrolling Animation Options] are [Fading], [Drop] and [Circle] animation
/// You have to choice one scrolling animations.

/// [Scrolling Options] are [Touch] [Floating Action Button] and [Scroll]
/// You can active every options for your widgets.

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

/// [isFadingScroll] is provide Fading effect while scrolling

//

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
  final Color dropColor;
  final ScrollingAnimationOptions scrollingAnimationOptions;

  static const MethodChannel _channel = MethodChannel('opscroll_web');

  const OpscrollWeb(
      {Key? key,
      required this.onePageChildren,
      required this.pageController,
      this.scrollingAnimationOptions = ScrollingAnimationOptions.Default,
      this.onTapGesture,
      this.floatingButtonBackgroundColor = Colors.grey,
      this.floatingButtonSplashColor = Colors.grey,
      this.isFloatingButtonActive = false,
      this.isTouchScrollingActive = false,
      this.dropColor = Colors.blueAccent,
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

class _OpscrollWebState extends State<OpscrollWeb> with SingleTickerProviderStateMixin {
  late PageController pageController;
  AnimationController? animationController;
  late bool isCircle;
  late bool isFading;
  late bool isDrop;

  @override
  void initState() {
    /// Have to choose only 1 scrolling animation
    if (widget.scrollingAnimationOptions == ScrollingAnimationOptions.Drop &&
            widget.scrollingAnimationOptions == ScrollingAnimationOptions.Fading ||
        widget.scrollingAnimationOptions == ScrollingAnimationOptions.Drop &&
            widget.scrollingAnimationOptions == ScrollingAnimationOptions.Circle ||
        widget.scrollingAnimationOptions == ScrollingAnimationOptions.Circle &&
            widget.scrollingAnimationOptions == ScrollingAnimationOptions.Fading) {
      throw Exception("Choose only 1 scrolling animations ");
    }

    isCircle = widget.scrollingAnimationOptions == ScrollingAnimationOptions.Circle;
    isFading = widget.scrollingAnimationOptions == ScrollingAnimationOptions.Fading;
    isDrop = widget.scrollingAnimationOptions == ScrollingAnimationOptions.Drop;

    /// [fadingScroll] and [circleScroll] animations is same
    /// both scroll animation after forward when completed will reverse
    /// so if fading or circle animation is true we define same controller
    if (isFading || isCircle) {
      animationController =
          AnimationController(vsync: this, duration: Duration(milliseconds: widget.scrollSpeed.inMilliseconds))
            ..addStatusListener((status) {
              if (status == AnimationStatus.completed) {
                animationController!.reverse();
              }
            });
      animationController!.addListener(() {
        setState(() {});
      });
    } else if (isDrop) {
      animationController =
          AnimationController(vsync: this, duration: Duration(milliseconds: widget.scrollSpeed.inMilliseconds))
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

    SchedulerBinding.instance.addPostFrameCallback((_) {
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
  MyScrollState scrollState = MyScrollState();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Listener(
      onPointerSignal: (event) {
        /// User scroll values listen in there
        /// if PointerScrollEvent [scrollDelta.dy] is negative
        /// it is meaning of user scroll to UP
        /// so we want to yield state [ScrollToNextPage].
        if (event is PointerScrollEvent) {
          bool isWillScroll = scrollState.startScroll(DateTime.now());
          if (isWillScroll) {
            /// [event.scrollDelta.dy.isNegative] is give us scroll direction
            /// if it is negative it means user scroll to UP
            makeScroll(!event.scrollDelta.dy.isNegative);
          }
          // scrollBloc.add(ScrollStart(scrollStartDateTime: DateTime.now(), isUp: event.scrollDelta.dy.isNegative));
        }
      },
      child: Scaffold(
        floatingActionButton: isInitialized
            ? widget.isFloatingButtonActive
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      /// Controll that is current page is first page
                      /// if current page is first we wont build
                      /// previous floating action button.
                      currentPageIndex != 0
                          ? FloatingActionButton(
                              backgroundColor: widget.floatingButtonBackgroundColor.withOpacity(0.3),
                              splashColor: widget.floatingButtonSplashColor,
                              onPressed: () {
                                if (isFading || isCircle) {
                                  reversedAnimatedScroll(false);
                                } else if (isDrop) {
                                  reversedAnimatedScroll(false);
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

                      /// Controll that is current page is last index
                      /// if current page is last we wont build
                      /// next floating action button.
                      currentPageIndex != widget.onePageChildren.length - 1
                          ? FloatingActionButton(
                              backgroundColor: widget.floatingButtonBackgroundColor.withOpacity(0.3),
                              splashColor: widget.floatingButtonSplashColor,
                              onPressed: () {
                                if (isFading || isCircle) {
                                  reversedAnimatedScroll(true);
                                } else if (isDrop) {
                                  reversedAnimatedScroll(true);
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

        /// [GestureDetector] is for mobile compability
        /// in mobile there are not scrolling mechanicsm
        /// we have to listen [Drag] events
        body: GestureDetector(
          onVerticalDragUpdate: (details) {
            bool isWillScroll = scrollState.startScroll(DateTime.now());
            if (isWillScroll) {
              /// [details.delta.dy.isNegative] is give us scroll direction
              /// if it is positive it means user scroll to UP
              makeScroll(details.delta.dy.isNegative);
            }
          },
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Opacity(
              opacity: isFading ? 1 - animationController!.value : 1,
              child: Stack(
                children: [
                  PageView(
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
                                      if (isFading || isCircle) {
                                        reversedAnimatedScroll(true);
                                      } else if (isDrop) {
                                        reversedAnimatedScroll(true);
                                      } else {
                                        defaultScroll(true);
                                      }
                                    }
                                  },
                              child: e,
                            ))
                        .toList(),
                  ),
                  isDrop
                      ? Align(
                          alignment: Alignment.bottomCenter,
                          child: DropAnimationWidget(
                              animateColor: widget.dropColor,
                              controller: animationController!,
                              screenHeight: MediaQuery.of(context).size.height,
                              screenWidth: MediaQuery.of(context).size.width),
                        )
                      : const SizedBox(),
                  isCircle
                      ? CircleAnimation(
                          screenHeight: MediaQuery.of(context).size.height,
                          screenWidth: MediaQuery.of(context).size.width,
                          animateColor: widget.dropColor,
                          animationController: animationController!,
                        )
                      : const SizedBox()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// This function is provide that animation forward
  /// and page changing
  Future<void> reversedAnimatedScroll(bool isNext) async {
    animationController!.forward();
    setState(() {
      isNext ? currentPageIndex++ : currentPageIndex--;
    });

    /// We have to wait current animation complete because we dont want
    /// to change page while scroll animation is forwarding.
    await Future.delayed(Duration(milliseconds: (widget.scrollSpeed.inMilliseconds).toInt()));
    isNext
        ? pageController.nextPage(duration: const Duration(milliseconds: 10), curve: widget.scrollCurve)
        : pageController.previousPage(duration: const Duration(milliseconds: 10), curve: widget.scrollCurve);
  }

  void defaultScroll(bool isNext) {
    if (isNext) {
      pageController.nextPage(duration: widget.scrollSpeed, curve: widget.scrollCurve);
      setState(() {
        currentPageIndex++;
      });
    } else {
      if (!(pageController.page!.toInt() == 0)) {
        pageController.previousPage(duration: widget.scrollSpeed, curve: widget.scrollCurve);
        setState(() {
          currentPageIndex--;
        });
      } else {
        debugPrint("*-*-* First Page,will not scroll to previous *-*-*");
      }
    }
  }

  makeScroll(bool isUp) {
    if (isUp) {
      if (pageController.page!.toInt() == widget.onePageChildren.length - 1) {
        debugPrint("*-*-* Last Page,will not scroll to next *-*-*");
      } else {
        if (isFading || isCircle) {
          reversedAnimatedScroll(true);
        } else if (isDrop) {
          reversedAnimatedScroll(true);
        } else {
          defaultScroll(true);
        }
      }
    } else {
      if (isFading || isCircle) {
        reversedAnimatedScroll(false);
      } else if (isDrop) {
        reversedAnimatedScroll(false);
      } else {
        defaultScroll(false);
      }
    }
  }
}
