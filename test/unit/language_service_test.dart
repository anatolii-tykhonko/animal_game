import 'package:flutter_test/flutter_test.dart';
import 'package:animal_game/l10n/app_strings.dart';
import 'package:animal_game/services/language_service.dart';

void main() {
  group('LanguageService', () {
    late LanguageService service;

    setUp(() => service = LanguageService());

    test('defaults to English', () {
      expect(service.language, AppLanguage.english);
    });

    test('setLanguage changes the language', () {
      service.setLanguage(AppLanguage.ukrainian);
      expect(service.language, AppLanguage.ukrainian);
    });

    test('setLanguage notifies listeners', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      service.setLanguage(AppLanguage.ukrainian);
      expect(notifyCount, 1);
    });

    test('setLanguage with same language does not notify', () {
      int notifyCount = 0;
      service.addListener(() => notifyCount++);

      service.setLanguage(AppLanguage.english); // same as default
      expect(notifyCount, 0);
    });

    test('can switch back to English', () {
      service.setLanguage(AppLanguage.ukrainian);
      service.setLanguage(AppLanguage.english);
      expect(service.language, AppLanguage.english);
    });
  });
}
