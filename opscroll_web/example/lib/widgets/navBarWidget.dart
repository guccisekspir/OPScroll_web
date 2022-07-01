import 'package:flutter/material.dart';
import 'package:opscroll_web_example/helpers/sizeHelper.dart';
import 'package:url_launcher/url_launcher_string.dart';

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          launchUrlString(assetslaunchURL);
        },
        child: Container(
          height: sizeHelper.height! * 0.1,
          width: sizeHelper.width! * 0.131,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(31),
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
