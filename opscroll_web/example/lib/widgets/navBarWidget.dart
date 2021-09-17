import 'package:flutter/material.dart';
import 'package:opscroll_web_example/helpers/sizeHelper.dart';
import 'package:url_launcher/url_launcher.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget(
      {Key? key,
      required this.sizeHelper,
      required this.assetPath,
      required this.assetslaunchURL})
      : super(key: key);
  final SizeHelper sizeHelper;
  final String assetPath;
  final String assetslaunchURL;

  void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          launchURL(assetslaunchURL);
        },
        child: Container(
          height: sizeHelper.height! * 0.1,
          width: sizeHelper.width! * 0.13,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: DecorationImage(
                  image: AssetImage(
                    assetPath,
                  ),
                  fit: BoxFit.fill)),
        ),
      ),
    );
  }
}
