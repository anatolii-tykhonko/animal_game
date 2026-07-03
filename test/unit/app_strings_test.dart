import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/l10n/app_strings.dart';

void main() {
  const allKeys = [
    'appTitle', 'start', 'chooseType',
    'pictureMode', 'picDesc', 'textMode', 'txtDesc', 'typeMode', 'typDesc',
    'score', 'steps', 'level', 'tapToHear',
    'savedGame', 'continueGame', 'newGame', 'nextLevel',
    'typeLabel', 'typeHint', 'check', 'hint',
    'correct', 'tryAgain', 'congrats', 'reachedEnd', 'playAgain', 'close',
    'cat', 'dog', 'cow', 'horse', 'goat', 'lion',
  ];

  group('AppStrings', () {
    test('every key exists in English', () {
      for (final key in allKeys) {
        final value = AppStrings.of(AppLanguage.english, key);
        expect(value, isNot(key),
            reason: 'Key "$key" missing from English dictionary');
        expect(value, isNotEmpty);
      }
    });

    test('every key exists in Ukrainian', () {
      for (final key in allKeys) {
        final value = AppStrings.of(AppLanguage.ukrainian, key);
        expect(value, isNot(key),
            reason: 'Key "$key" missing from Ukrainian dictionary');
        expect(value, isNotEmpty);
      }
    });

    test('English and Ukrainian values differ for translated strings', () {
      for (final key in allKeys) {
        final en = AppStrings.of(AppLanguage.english, key);
        final uk = AppStrings.of(AppLanguage.ukrainian, key);
        expect(en, isNot(uk),
            reason: 'Key "$key" has identical EN/UK value — translation missing');
      }
    });

    test('returns key as fallback for missing key', () {
      const missing = 'nonexistent_key_xyz';
      expect(AppStrings.of(AppLanguage.english, missing), missing);
      expect(AppStrings.of(AppLanguage.ukrainian, missing), missing);
    });

    test('animal ids map to correct English names', () {
      expect(AppStrings.of(AppLanguage.english, 'cat'), 'Cat');
      expect(AppStrings.of(AppLanguage.english, 'dog'), 'Dog');
      expect(AppStrings.of(AppLanguage.english, 'cow'), 'Cow');
      expect(AppStrings.of(AppLanguage.english, 'horse'), 'Horse');
      expect(AppStrings.of(AppLanguage.english, 'goat'), 'Goat');
      expect(AppStrings.of(AppLanguage.english, 'lion'), 'Lion');
    });

    test('animal ids map to correct Ukrainian names', () {
      expect(AppStrings.of(AppLanguage.ukrainian, 'cat'), 'Кіт');
      expect(AppStrings.of(AppLanguage.ukrainian, 'dog'), 'Собака');
      expect(AppStrings.of(AppLanguage.ukrainian, 'cow'), 'Корова');
      expect(AppStrings.of(AppLanguage.ukrainian, 'horse'), 'Кінь');
      expect(AppStrings.of(AppLanguage.ukrainian, 'goat'), 'Коза');
      expect(AppStrings.of(AppLanguage.ukrainian, 'lion'), 'Лев');
    });
  });
}
