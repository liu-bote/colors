import 'package:color_spot/data/color_name_translations.dart';
import 'package:color_spot/data/crayola_colors.dart';
import 'package:color_spot/l10n/app_strings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('palette is the official 120-crayon box with unique names', () {
    expect(crayolaColors.length, 120);
    final names = crayolaColors.map((c) => c.name).toSet();
    expect(names.length, 120);
  });

  test('every supported language translates every color', () {
    for (final lang in supportedLanguages) {
      if (lang.code == 'en') continue;
      final translations = colorNameTranslations[lang.code];
      expect(translations, isNotNull, reason: 'missing map for ${lang.code}');
      for (final c in crayolaColors) {
        expect(translations![c.name], isNotNull,
            reason: '${lang.code} missing "${c.name}"');
        expect(c.nameIn(lang.code), isNot(equals('')));
      }
      // No stale entries for colors that left the palette.
      final names = crayolaColors.map((c) => c.name).toSet();
      for (final key in translations!.keys) {
        expect(names.contains(key), isTrue,
            reason: '${lang.code} has stale entry "$key"');
      }
    }
  });

  test('every supported language has UI strings', () {
    for (final lang in supportedLanguages) {
      final s = appStringsFor(lang.code);
      expect(s.appTitle, isNotEmpty, reason: 'no strings for ${lang.code}');
      expect(s.levelLabel(3, 100), contains('3'));
      expect(s.bestLevel(7), contains('7'));
    }
  });
}
