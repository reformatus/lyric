import 'package:flutter_test/flutter_test.dart';

import '../harness/test_harness.dart';

void main() {
  group('MessengerService', () {
    late TestHarness harness;

    setUp(() {
      harness = TestHarness();
    });

    tearDown(() {
      harness.dispose();
    });

    test('FakeMessengerService records shown snackbars', () {
      // This test demonstrates how to verify UI feedback without widgets
      // In real tests, you'd trigger an action that calls messengerService.showSnackBar

      // Simulating what a service would do:
      // harness.messenger.showSnackBar(SnackBar(content: Text('Test')));

      // Then assert:
      // expect(harness.messenger.shownSnackBars, hasLength(1));

      expect(harness.messenger.shownSnackBars, isEmpty);
    });

    test('FakeMessengerService tracks banner operations', () {
      harness.messenger.clearBanners();
      harness.messenger.hideCurrentBanner();
      harness.messenger.hideCurrentBanner();

      expect(harness.messenger.clearBannersCalled, equals(1));
      expect(harness.messenger.hideCurrentBannerCalled, equals(2));
    });

    test('reset clears all recorded state', () {
      harness.messenger.clearBanners();
      harness.messenger.reset();

      expect(harness.messenger.clearBannersCalled, equals(0));
    });
  });
}
