import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jufu/app_settings.dart';
import 'package:jufu/main.dart';
import 'package:jufu/launch_experience.dart';

void main() {
  testWidgets('first launch shows the guide and skip persists completion', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'language_code': 'en'});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      JufuApp(
        settings: AppSettingsController(preferences),
        preferences: preferences,
      ),
    );

    expect(find.text('Jufu'), findsOneWidget);
    expect(find.text('Your story starts with a photo'), findsNothing);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();
    expect(find.text('Your story starts with a photo'), findsOneWidget);
    expect(
      preferences.getBool(LaunchExperience.onboardingCompletedKey),
      isNull,
    );

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();
    expect(find.text('Choose from Photos'), findsOneWidget);
    expect(
      preferences.getBool(LaunchExperience.onboardingCompletedKey),
      isTrue,
    );
  });

  testWidgets('onboarding steps lead to the editor', (tester) async {
    SharedPreferences.setMockInitialValues({'language_code': 'en'});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      JufuApp(
        settings: AppSettingsController(preferences),
        preferences: preferences,
      ),
    );
    expect(find.text('Jufu'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Find its quiet glow'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Make it yours'), findsOneWidget);
    await tester.tap(find.text('Start editing'));
    await tester.pumpAndSettle();

    expect(find.text('Choose from Photos'), findsOneWidget);
    expect(
      preferences.getBool(LaunchExperience.onboardingCompletedKey),
      isTrue,
    );
  });

  testWidgets('returning users bypass onboarding in the selected language', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'language_code': 'zh',
      LaunchExperience.onboardingCompletedKey: true,
    });
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      JufuApp(
        settings: AppSettingsController(preferences),
        preferences: preferences,
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('从一张照片开始'), findsNothing);
    expect(find.text('Jufu'), findsOneWidget);
    expect(find.text('从相册选一张'), findsOneWidget);
  });

  testWidgets('guide remains usable on a compact screen', (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    SharedPreferences.setMockInitialValues({'language_code': 'zh'});
    final preferences = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      JufuApp(
        settings: AppSettingsController(preferences),
        preferences: preferences,
      ),
    );
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('从一张照片开始'), findsOneWidget);
    expect(find.text('继续'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
