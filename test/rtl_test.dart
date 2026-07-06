import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:color_spot/main.dart';
import 'package:color_spot/services/settings_service.dart';

void main() {
  testWidgets('Arabic primary language flips the app to RTL', (tester) async {
    SharedPreferences.setMockInitialValues({'primary_lang': 'ar'});
    final settings = SettingsService();
    await settings.load();

    await tester.pumpWidget(ColorSpotApp(settings: settings));

    final context = tester.element(find.byType(Scaffold));
    expect(Directionality.of(context), TextDirection.rtl);
  });

  testWidgets('LTR languages keep the app LTR', (tester) async {
    SharedPreferences.setMockInitialValues({'primary_lang': 'zh'});
    final settings = SettingsService();
    await settings.load();

    await tester.pumpWidget(ColorSpotApp(settings: settings));

    final context = tester.element(find.byType(Scaffold));
    expect(Directionality.of(context), TextDirection.ltr);
  });
}
