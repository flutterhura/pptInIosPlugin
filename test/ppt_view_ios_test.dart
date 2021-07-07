import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ppt_view_ios/ppt_view_ios.dart';

void main() {
  const MethodChannel channel = MethodChannel('ppt_view_ios');

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

  });
}
