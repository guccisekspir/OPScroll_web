import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:octo_image/octo_image.dart';
import 'package:opscroll_web_example/helpers/sizeHelper.dart';
import 'package:video_player/video_player.dart';

class LargeScreenMainPageBodyWidget extends StatelessWidget {
  const LargeScreenMainPageBodyWidget(
      {Key? key,
      required this.backgroundColor,
      required this.contentHeight,
      required this.contentWidth,
      this.centralWidgets,
      required this.isInit,
      this.controller,
      required this.photoAssetPath,
      required this.animationController,
      required this.labelString,
      required this.bodyString,
      required this.sizeHelper})
      : super(key: key);
  final Color backgroundColor;
  final double contentHeight;
  final double contentWidth;
  final List<String>? centralWidgets;
  final bool isInit;
  final VideoPlayerController? controller;
  final String photoAssetPath;
  final AnimationController animationController;
  final String labelString;
  final String bodyString;
  final SizeHelper sizeHelper;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: backgroundColor,
            height: contentHeight,
            width: contentWidth,
            child: centralWidgets != null
                ? Stack(
                    children: centralWidgets!.length > 1
                        ? [
                            Align(
                              alignment: Alignment.topLeft,
                              child: SizedBox(
                                width: contentWidth,
                                height: contentHeight / 2,
                                child: Image.asset(centralWidgets![0]),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                width: contentWidth,
                                height: contentHeight / 2,
                                child: Image.asset(centralWidgets![1]),
                              ),
                            ),
                          ]
                        : [
                            Align(
                                alignment: Alignment.center,
                                child: SizedBox(
                                  width: contentWidth,
                                  height: contentHeight,
                                  child: Image.asset(centralWidgets![0]),
                                ))
                          ],
                  )
                : isInit
                    ? VideoPlayer(controller!)
                    : OctoImage(
                        placeholderBuilder: OctoPlaceholder.blurHash(
                          'LEHV6nWB2yk8pyo0adR*.7kCMdnj',
                        ),
                        errorBuilder: OctoError.icon(color: Colors.red),
                        fit: BoxFit.fill,
                        image: AssetImage(photoAssetPath)),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: SizedBox(
              height: contentHeight,
              width: contentWidth,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 300),
                      opacity: animationController.value,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: sizeHelper.height! * 0.5,
                        ),
                        child: AutoSizeText(labelString,
                            textAlign: TextAlign.start,
                            style: GoogleFonts.roboto(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            )),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: sizeHelper.height! * 0.2,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: animationController.value.floorToDouble(),
                          child: AutoSizeText(bodyString,
                              style: GoogleFonts.roboto(
                                fontSize: 30,
                                color: Colors.white70,
                                fontWeight: FontWeight.normal,
                              )),
                        ),
                      ))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
