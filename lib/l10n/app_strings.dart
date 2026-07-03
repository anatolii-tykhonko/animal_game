enum AppLanguage { english, ukrainian }

class AppStrings {
  static const Map<AppLanguage, Map<String, String>> _data = {
    AppLanguage.english: {
      // App
      'appTitle': 'Animal Sounds Game',
      // Home
      'start': 'Start',
      // Game select
      'chooseType': 'Choose Game Type',
      'pictureMode': 'Picture Mode',
      'picDesc': 'Hear the sound and tap the correct animal picture',
      'textMode': 'Text Mode',
      'txtDesc': 'Hear the sound and tap the correct animal name',
      'typeMode': 'Type Mode',
      'typDesc': 'Hear the sound and type the animal name',
      // Game HUD
      'score': 'Score',
      'steps': 'Steps',
      'level': 'Level',
      // Continue dialog
      'savedGame': 'You have a saved game',
      'continueGame': 'Continue',
      'newGame': 'New Game',
      // Completion
      'nextLevel': 'Next Level',
      // Sound card
      'tapToHear': 'Tap to hear!',
      // Type answer field
      'typeLabel': 'Type the animal name:',
      'typeHint': 'e.g. cat, dog, cow...',
      'check': 'Check',
      'hint': 'Hint',
      // Overlays
      'correct': 'Correct!',
      'tryAgain': 'Try Again!',
      'congrats': 'Congratulations!',
      'reachedEnd': 'You reached the finish!',
      'playAgain': 'Play Again',
      'close': 'Close',
      // Animals
      'cat': 'Cat',
      'dog': 'Dog',
      'cow': 'Cow',
      'horse': 'Horse',
      'goat': 'Goat',
      'lion': 'Lion',
    },
    AppLanguage.ukrainian: {
      // App
      'appTitle': 'Гра Звуки Тварин',
      // Home
      'start': 'Почати',
      // Game select
      'chooseType': 'Оберіть тип гри',
      'pictureMode': 'Режим картинок',
      'picDesc': 'Почуй звук і натисни на правильну картинку',
      'textMode': 'Текстовий режим',
      'txtDesc': 'Почуй звук і натисни на правильну назву',
      'typeMode': 'Режим введення',
      'typDesc': 'Почуй звук і введи назву тварини',
      // Game HUD
      'score': 'Рахунок',
      'steps': 'Кроки',
      'level': 'Рівень',
      // Continue dialog
      'savedGame': 'У вас є збережена гра',
      'continueGame': 'Продовжити',
      'newGame': 'Нова гра',
      // Completion
      'nextLevel': 'Наступний рівень',
      // Sound card
      'tapToHear': 'Натисни, щоб почути!',
      // Type answer field
      'typeLabel': 'Введи назву тварини:',
      'typeHint': 'напр. кіт, пес, корова...',
      'check': 'Перевірити',
      'hint': 'Підказка',
      // Overlays
      'correct': 'Правильно!',
      'tryAgain': 'Спробуй ще!',
      'congrats': 'Вітаємо!',
      'reachedEnd': 'Ти досяг фінішу!',
      'playAgain': 'Грати знову',
      'close': 'Закрити',
      // Animals
      'cat': 'Кіт',
      'dog': 'Собака',
      'cow': 'Корова',
      'horse': 'Кінь',
      'goat': 'Коза',
      'lion': 'Лев',
    },
  };

  static String of(AppLanguage lang, String key) =>
      _data[lang]?[key] ?? key;
}
