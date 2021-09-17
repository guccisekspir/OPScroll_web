import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:opscroll_web_example/helpers/sizeHelper.dart';
import 'package:opscroll_web_example/widgets/smallScreenMainPage.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'largeScreenMainPage.dart';

class MainPages extends StatefulWidget {
  final Color color;
  final String assetString;
  final PageController pageController;
  final bool isEnd;
  final String labelString;
  final String bodyString;
  final String photoAssetPath;
  final List<String>? centralWidgets;

  const MainPages(
      {Key? key,
      required this.color,
      required this.photoAssetPath,
      required this.assetString,
      required this.isEnd,
      required this.bodyString,
      required this.labelString,
      this.centralWidgets,
      required this.pageController})
      : super(key: key);

  @override
  _MainPagesState createState() => _MainPagesState();
}

class _MainPagesState extends State<MainPages>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? controller;
  bool isInit = false;
  late AnimationController animationController;
  @override
  void initState() {
    controller = VideoPlayerController.network(widget.assetString)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {
          controller!.setLooping(true);
          isInit = true;
        });
      });

    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));

    debugPrint(widget.color.toString() + "initte");

    super.initState();
  }

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  @override
  Widget build(BuildContext context) {
    SizeHelper sizeHelper = SizeHelper(fetchedContext: context);

    return VisibilityDetector(
      key: Key(widget.color.toString()),
      onVisibilityChanged: (VisibilityInfo visibilityInfo) {
        controller!.play();
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        if (visiblePercentage == 0) {
          controller!.pause();
          animationController.reset();
        } else if (visiblePercentage == 100) {
          animationController.forward();
          animationController.addListener(() {
            setState(() {});
          });
        }
        debugPrint(
            'Widget ${visibilityInfo.key} is ${visiblePercentage}% visible');
      },
      child: GestureDetector(
        onTap: () {
          if (widget.isEnd) {
            widget.pageController.previousPage(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeIn);
          } else {
            widget.pageController.nextPage(
                duration: const Duration(milliseconds: 900),
                curve: Curves.easeIn);
          }
        },
        child: Scaffold(
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              FloatingActionButton(
                backgroundColor: Colors.grey.withOpacity(0.3),
                splashColor: Colors.pink,
                focusColor: Colors.pink,
                onPressed: () {
                  widget.pageController.previousPage(
                      duration: const Duration(milliseconds: 900),
                      curve: Curves.easeIn);
                },
                child: const Icon(Icons.arrow_upward_sharp),
              ),
              const SizedBox(
                height: 10,
              ),
              !widget.isEnd
                  ? FloatingActionButton(
                      backgroundColor: Colors.grey.withOpacity(0.3),
                      onPressed: () {
                        widget.pageController.nextPage(
                            duration: const Duration(milliseconds: 900),
                            curve: Curves.easeIn);
                      },
                      child: const Icon(
                        Icons.arrow_downward_sharp,
                      ))
                  : const SizedBox(),
            ],
          ),
          body: Container(
              height: sizeHelper.height,
              width: sizeHelper.width,
              color: widget.color,
              child: isSmallScreen(context)
                  ? SmallScreenMainPageBodyWidget(
                      centralWidgets: widget.centralWidgets,
                      backgroundColor: widget.color,
                      contentHeight: sizeHelper.height! * 0.4,
                      contentWidth: sizeHelper.width! * 0.8,
                      isInit: isInit,
                      controller: controller,
                      photoAssetPath: widget.photoAssetPath,
                      animationController: animationController,
                      labelString: widget.labelString,
                      bodyString: widget.bodyString,
                      sizeHelper: sizeHelper)
                  : LargeScreenMainPageBodyWidget(
                      centralWidgets: widget.centralWidgets,
                      backgroundColor: widget.color,
                      contentHeight: sizeHelper.height! * 0.7,
                      contentWidth: sizeHelper.width! * 0.5,
                      isInit: isInit,
                      controller: controller,
                      photoAssetPath: widget.photoAssetPath,
                      animationController: animationController,
                      labelString: widget.labelString,
                      bodyString: widget.bodyString,
                      sizeHelper: sizeHelper)),
        ),
      ),
    );
  }
}
