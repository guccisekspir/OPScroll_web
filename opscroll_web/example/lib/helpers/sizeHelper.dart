import 'package:flutter/material.dart';

class SizeHelper {
  BuildContext? ccontext;
  double? width;
  double? height;

  static final SizeHelper _sizeHelper = SizeHelper._internal();

  SizeHelper._internal();

  factory SizeHelper({BuildContext? fetchedContext, bool? isTesting}) {
    //LnadPage'de context'i verdiğimiz için sonraki yerlerde
    //tekrar tekrar çağırmamak için bunu yapıyoruz
    if (isTesting != null) {
      _sizeHelper.width = 600;
      _sizeHelper.height = 1200;
    } else {
      if (fetchedContext != null) {
        _sizeHelper.ccontext = fetchedContext;
      } else {
        //size helper context null
      }
      if (_sizeHelper.width == null && _sizeHelper.height == null) {
        if (_sizeHelper.ccontext != null) {
          _sizeHelper.width = MediaQuery.of(_sizeHelper.ccontext!).size.width;
          _sizeHelper.height = MediaQuery.of(_sizeHelper.ccontext!).size.height;
        }
      }
    }

    return _sizeHelper;
  }
}
