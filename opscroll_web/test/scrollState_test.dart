import 'package:flutter_test/flutter_test.dart';
import 'package:opscroll_web/scrollState.dart';

void main() {
  test("is first scroll will allow scroll", () {
    MyScrollState scrollState = MyScrollState();
    bool isScrollAllowed = scrollState.startScroll(DateTime.now());

    expect(isScrollAllowed, true);
  });

  test("is timeless scroll will allow scroll", () {
    MyScrollState scrollState = MyScrollState();
    scrollState.startScroll(DateTime.now());
    scrollState.startScroll(DateTime.now());
    bool isScrollAllowed = scrollState.startScroll(DateTime.now());

    expect(isScrollAllowed, false);
  });

  test("is delayed scroll will allow scroll", () async {
    MyScrollState scrollState = MyScrollState();
    scrollState.startScroll(DateTime.now());
    await Future.delayed(const Duration(seconds: 2));
    bool isScrollAllowed = scrollState.startScroll(DateTime.now());
    expect(isScrollAllowed, true);
  });
}
