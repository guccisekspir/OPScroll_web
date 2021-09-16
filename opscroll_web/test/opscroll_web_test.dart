import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opscroll_web/opscroll_web.dart';

void main() {
  const MethodChannel channel = MethodChannel('opscroll_web');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await OpscrollWeb.platformVersion, '42');
  });
}
