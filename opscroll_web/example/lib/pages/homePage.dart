import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:opscroll_web/opscroll_web.dart';
import 'package:opscroll_web_example/helpers/sizeHelper.dart';
import 'package:opscroll_web_example/helpers/themeHelper.dart';
import 'package:opscroll_web_example/widgets/mainPage.dart';
import 'package:opscroll_web_example/widgets/navBarWidget.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> assetsList = [
    "https://smoody.app/video/rocket.mp4",
    "https://smoody.app/video/jukebox.mp4",
    "https://smoody.app/video/clock.mp4",
    "https://smoody.app/video/graphs.mp4"
  ];

  List<String> photoAssetList = [
    "assets/rocketFirst.png",
    "assets/jukeboxFirst.png",
    "assets/clockFirst.png",
    "assets/graphsFirst.png"
  ];

  late SizeHelper sizeHelper;
  late ThemeHelper themeHelper;

  bool isInit = false;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      sizeHelper = SizeHelper(fetchedContext: context);
      themeHelper = ThemeHelper(fetchedContext: context);
      setState(() {
        isInit = true;
      });
    });
  }

  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: isInit
            ? Stack(
                children: [
                  OpscrollWeb(
                    isFloatingButtonActive: true,
                    isTouchScrollingActive: true,
                    pageController: pageController,
                    scrollingAnimationOptions: ScrollingAnimationOptions.Drop,
                    scrollSpeed: const Duration(milliseconds: 600),
                    onePageChildren: [
                      Container(
                        color: Colors.cyanAccent,
                        child: Column(
                          children: [
                            const Spacer(),
                            Container(
                              height: sizeHelper.height! * 0.4,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage("assets/onlyPng.png"))),
                            ),
                            Center(
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    maxHeight: sizeHelper.height! * 0.5,
                                    maxWidth: sizeHelper.width! * 0.6),
                                child: AutoSizeText(
                                    "A simple and easy to use library that creates OnePage sites for Flutter Web Developers! ",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.roboto(
                                      fontSize: sizeHelper.height! * 0.07,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      MainPages(
                        color: themeHelper.land1Purp,
                        isEnd: false,
                        bodyString:
                            "Make a beautiful and smooth landing pages with OPScroll with in minutes",
                        labelString: "Boost your Flutter Web Experience",
                        pageController: pageController,
                        assetString: assetsList[0],
                        photoAssetPath: photoAssetList[0],
                      ),
                      MainPages(
                        color: themeHelper.lan3dAmber,
                        isEnd: false,
                        bodyString:
                            "Just use OPScroll and only focus your products",
                        labelString:
                            "Don't waste time for scrolling mechanicsm",
                        pageController: pageController,
                        assetString: assetsList[2],
                        photoAssetPath: photoAssetList[2],
                      ),
                      MainPages(
                        color: themeHelper.land4Spring,
                        isEnd: false,
                        bodyString:
                            "Import OPScroll,define your pages,Taaa daaa",
                        labelString: "Easy to Use",
                        pageController: pageController,
                        centralWidgets: const ["assets/usage.png"],
                        assetString: assetsList[2],
                        photoAssetPath: photoAssetList[2],
                      ),
                      MainPages(
                        color: themeHelper.primaryColor,
                        isEnd: true,
                        bodyString:
                            "Make your landing pages with OPScroll power <3",
                        labelString: "Go pub.dev",
                        pageController: pageController,
                        centralWidgets: const ["assets/social.png"],
                        assetString: assetsList[2],
                        photoAssetPath: photoAssetList[2],
                      ),
                    ],
                  ),
                  Container(
                    height: sizeHelper.height! * 0.1,
                    color: Colors.grey.withOpacity(0.5),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Container(
                            height: sizeHelper.height! * 0.1,
                            width: sizeHelper.width! * 0.2,
                            decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage("assets/onlyPng.png"))),
                          ),
                        ),
                        const Spacer(),
                        NavBarWidget(
                          assetPath: "assets/pubdev.png",
                          assetslaunchURL:
                              'https://pub.dev/packages/opscroll_web',
                          sizeHelper: sizeHelper,
                        ),
                        NavBarWidget(
                          assetPath: "assets/coffee.png",
                          assetslaunchURL:
                              'https://www.buymeacoffee.com/shekspir',
                          sizeHelper: sizeHelper,
                        ),
                        NavBarWidget(
                          assetPath: "assets/github2.png",
                          assetslaunchURL:
                              'https://github.com/guccisekspir/OPScroll_web',
                          sizeHelper: sizeHelper,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Container(),
      ),
    );
  }
}
